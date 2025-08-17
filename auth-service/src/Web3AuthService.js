const express = require('express');
const jwt = require('jsonwebtoken');
const { Web3 } = require('web3');
const { ethers } = require('ethers');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { body, validationResult } = require('express-validator');
require('dotenv').config();

class Web3AuthService {
  constructor() {
    this.app = express();
    this.web3 = new Web3(process.env.BLOCKCHAIN_RPC_URL);
    
    // Asgardeo client configuration
    this.authClient = {
      baseUrl: process.env.ASGARDEO_BASE_URL,
      clientId: process.env.ASGARDEO_CLIENT_ID,
      clientSecret: process.env.ASGARDEO_CLIENT_SECRET,
      scopes: process.env.ASGARDEO_SCOPES.split(' '),
      redirectUri: process.env.ASGARDEO_REDIRECT_URI
    };
    
    this.setupMiddleware();
    this.setupRoutes();
  }

  setupMiddleware() {
    // Security middleware
    this.app.use(helmet());
    
    // CORS configuration
    this.app.use(cors({
      origin: process.env.FRONTEND_URL,
      credentials: true,
      methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization']
    }));

    // Rate limiting
    const limiter = rateLimit({
      windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 60000,
      max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
      message: { error: 'Too many requests from this IP' },
      standardHeaders: true,
      legacyHeaders: false,
    });
    this.app.use('/auth', limiter);

    // Body parser
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true }));

    // Health check
    this.app.get('/health', (req, res) => {
      res.json({ status: 'OK', timestamp: new Date().toISOString() });
    });
  }

  setupRoutes() {
    // Step 1: Initiate wallet authentication
    this.app.post('/auth/wallet/initiate', 
      this.validateWalletAddress(),
      this.initiateWalletAuth.bind(this)
    );
    
    // Step 2: Verify wallet signature and smart contract
    this.app.post('/auth/wallet/verify', 
      this.validateWalletVerification(),
      this.verifyWalletAndContract.bind(this)
    );
    
    // Step 3: Exchange for JWT via Asgardeo
    this.app.post('/auth/jwt/exchange', 
      this.validateJWTExchange(),
      this.exchangeForJWT.bind(this)
    );
    
    // Step 4: Verify JWT with Asgardeo
    this.app.post('/auth/jwt/verify',
      this.verifyJWTWithAsgardeo.bind(this)
    );
    
    // Protected route example
    this.app.get('/api/protected', 
      this.verifyJWT.bind(this), 
      this.protectedEndpoint.bind(this)
    );
    
    // Token refresh
    this.app.post('/auth/refresh', 
      this.refreshToken.bind(this)
    );

    // Get user profile
    this.app.get('/auth/profile',
      this.verifyJWT.bind(this),
      this.getUserProfile.bind(this)
    );

    // Logout
    this.app.post('/auth/logout',
      this.logout.bind(this)
    );
  }

  // Validation middleware
  validateWalletAddress() {
    return [
      body('walletAddress')
        .isString()
        .isLength({ min: 42, max: 42 })
        .matches(/^0x[a-fA-F0-9]{40}$/)
        .withMessage('Invalid Ethereum address format'),
      this.handleValidationErrors
    ];
  }

  validateWalletVerification() {
    return [
      body('walletAddress')
        .isString()
        .isLength({ min: 42, max: 42 })
        .matches(/^0x[a-fA-F0-9]{40}$/)
        .withMessage('Invalid Ethereum address format'),
      body('signature')
        .isString()
        .isLength({ min: 132, max: 132 })
        .matches(/^0x[a-fA-F0-9]{130}$/)
        .withMessage('Invalid signature format'),
      body('nonce')
        .isString()
        .isLength({ min: 66, max: 66 })
        .matches(/^0x[a-fA-F0-9]{64}$/)
        .withMessage('Invalid nonce format'),
      this.handleValidationErrors
    ];
  }

  validateJWTExchange() {
    return [
      body('tempToken')
        .isString()
        .notEmpty()
        .withMessage('Temporary token is required'),
      this.handleValidationErrors
    ];
  }

  handleValidationErrors(req, res, next) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation failed',
        details: errors.array()
      });
    }
    next();
  }

  // Generate challenge for wallet signature
  async initiateWalletAuth(req, res) {
    try {
      const { walletAddress } = req.body;
      
      // Generate nonce/challenge
      const nonce = ethers.hexlify(ethers.randomBytes(32));
      const timestamp = Date.now();
      
      const challenge = {
        message: `Please sign this message to authenticate with Transparent Governance Platform.

Nonce: ${nonce}
Timestamp: ${timestamp}
Address: ${walletAddress.toLowerCase()}

This request will not trigger a blockchain transaction or cost any gas fees.`,
        nonce,
        timestamp,
        walletAddress: walletAddress.toLowerCase()
      };

      // Store challenge temporarily (5 minutes)
      this.storeChallenge(walletAddress, challenge);

      console.log(`Challenge initiated for wallet: ${walletAddress}`);
      
      res.json({ 
        success: true,
        challenge: challenge.message, 
        nonce,
        expiresIn: 300 // 5 minutes
      });
    } catch (error) {
      console.error('Wallet auth initiation error:', error);
      res.status(500).json({ 
        error: 'Failed to initiate wallet authentication',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  // Verify wallet signature and smart contract authorization
  async verifyWalletAndContract(req, res) {
    try {
      const { walletAddress, signature, nonce } = req.body;
      
      // Verify challenge exists and is valid
      const storedChallenge = this.getStoredChallenge(walletAddress);
      if (!storedChallenge || storedChallenge.nonce !== nonce) {
        return res.status(401).json({ 
          error: 'Invalid or expired challenge',
          code: 'CHALLENGE_INVALID'
        });
      }

      // Check if challenge is expired (5 minutes)
      if (Date.now() - storedChallenge.timestamp > 5 * 60 * 1000) {
        this.removeStoredChallenge(walletAddress);
        return res.status(401).json({ 
          error: 'Challenge expired',
          code: 'CHALLENGE_EXPIRED'
        });
      }

      // Verify signature matches wallet
      let recoveredAddress;
      try {
        recoveredAddress = ethers.verifyMessage(storedChallenge.message, signature);
      } catch (sigError) {
        return res.status(401).json({ 
          error: 'Invalid signature format',
          code: 'SIGNATURE_INVALID'
        });
      }

      if (recoveredAddress.toLowerCase() !== walletAddress.toLowerCase()) {
        return res.status(401).json({ 
          error: 'Signature verification failed - wallet mismatch',
          code: 'WALLET_MISMATCH'
        });
      }

      // Check smart contract authorization
      let isAuthorized = false;
      try {
        isAuthorized = await this.checkSmartContractAuthorization(walletAddress);
      } catch (contractError) {
        console.warn('Smart contract check failed, allowing for development:', contractError.message);
        // In development, allow if contract check fails
        isAuthorized = process.env.NODE_ENV === 'development';
      }
      
      if (!isAuthorized) {
        return res.status(403).json({ 
          error: 'Wallet not authorized by smart contract',
          code: 'CONTRACT_UNAUTHORIZED',
          authorized: false 
        });
      }

      // Generate temporary token for Asgardeo exchange
      const tempToken = jwt.sign(
        {
          walletAddress: walletAddress.toLowerCase(),
          contractAuthorized: true,
          timestamp: Date.now(),
          type: 'temp_auth'
        },
        process.env.TEMP_JWT_SECRET,
        { expiresIn: '5m' }
      );

      // Clean up challenge
      this.removeStoredChallenge(walletAddress);

      console.log(`Wallet verified successfully: ${walletAddress}`);

      res.json({
        success: true,
        authorized: true,
        tempToken,
        walletAddress: walletAddress.toLowerCase(),
        expiresIn: 300
      });

    } catch (error) {
      console.error('Wallet verification error:', error);
      res.status(500).json({ 
        error: 'Wallet verification failed',
        code: 'VERIFICATION_ERROR',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  // Exchange temporary token for proper JWT via Asgardeo
  async exchangeForJWT(req, res) {
    try {
      const { tempToken } = req.body;
      
      // Verify temp token
      let decoded;
      try {
        decoded = jwt.verify(tempToken, process.env.TEMP_JWT_SECRET);
      } catch (jwtError) {
        return res.status(401).json({
          error: 'Invalid or expired temporary token',
          code: 'TEMP_TOKEN_INVALID'
        });
      }

      if (decoded.type !== 'temp_auth') {
        return res.status(401).json({
          error: 'Invalid token type',
          code: 'INVALID_TOKEN_TYPE'
        });
      }

      // Create user profile for Asgardeo
      const userProfile = await this.createOrUpdateAsgardeoUser(decoded);
      
      // Generate JWT with user claims
      const jwtPayload = {
        sub: userProfile.id,
        wallet_address: decoded.walletAddress,
        contract_authorized: decoded.contractAuthorized,
        user_id: userProfile.id,
        iss: 'transparent-governance-platform',
        aud: process.env.FRONTEND_URL,
        iat: Math.floor(Date.now() / 1000),
        exp: Math.floor(Date.now() / 1000) + (24 * 60 * 60) // 24 hours
      };

      const accessToken = jwt.sign(jwtPayload, process.env.JWT_SECRET);
      
      // Generate refresh token
      const refreshToken = jwt.sign(
        {
          sub: userProfile.id,
          wallet_address: decoded.walletAddress,
          type: 'refresh'
        },
        process.env.JWT_SECRET,
        { expiresIn: '7d' }
      );

      console.log(`JWT issued for wallet: ${decoded.walletAddress}`);

      res.json({
        success: true,
        accessToken,
        refreshToken,
        expiresIn: 86400, // 24 hours in seconds
        tokenType: 'Bearer',
        user: {
          id: userProfile.id,
          walletAddress: decoded.walletAddress,
          contractAuthorized: decoded.contractAuthorized
        }
      });

    } catch (error) {
      console.error('JWT exchange error:', error);
      res.status(500).json({ 
        error: 'Token exchange failed',
        code: 'TOKEN_EXCHANGE_ERROR',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  // Verify JWT with custom validation
  async verifyJWTWithAsgardeo(req, res) {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ 
          error: 'Missing or invalid authorization header',
          code: 'MISSING_TOKEN'
        });
      }

      const token = authHeader.substring(7);
      
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        res.json({
          valid: true,
          user: {
            id: decoded.sub,
            walletAddress: decoded.wallet_address,
            contractAuthorized: decoded.contract_authorized,
            issuedAt: decoded.iat,
            expiresAt: decoded.exp
          }
        });
      } catch (jwtError) {
        res.status(401).json({
          valid: false,
          error: 'Invalid or expired token',
          code: 'TOKEN_INVALID'
        });
      }
    } catch (error) {
      console.error('JWT verification error:', error);
      res.status(500).json({ 
        error: 'Token verification failed',
        code: 'VERIFICATION_ERROR'
      });
    }
  }

  // Smart contract authorization check
  async checkSmartContractAuthorization(walletAddress) {
    try {
      if (!process.env.CONTRACT_ADDRESS || !process.env.CONTRACT_ABI) {
        console.warn('Smart contract not configured, skipping authorization check');
        return true; // Allow in development if not configured
      }

      const contract = new this.web3.eth.Contract(
        JSON.parse(process.env.CONTRACT_ABI),
        process.env.CONTRACT_ADDRESS
      );

      // Call your smart contract's authorization method
      const isAuthorized = await contract.methods
        .isAuthorized(walletAddress)
        .call();

      return isAuthorized;
    } catch (error) {
      console.error('Smart contract check error:', error);
      // In development, return true if contract check fails
      return process.env.NODE_ENV === 'development';
    }
  }

  // Create or update user profile (simulate Asgardeo user creation)
  async createOrUpdateAsgardeoUser(decoded) {
    try {
      // This simulates user creation in Asgardeo
      // In a real implementation, you would use Asgardeo's SCIM API
      const userData = {
        id: 'user-' + decoded.walletAddress.slice(2, 10), // Use first 8 chars after 0x
        userName: decoded.walletAddress,
        wallet_address: decoded.walletAddress,
        contract_authorized: decoded.contractAuthorized,
        created_at: new Date().toISOString(),
        last_auth: new Date().toISOString()
      };

      console.log('User profile created/updated:', userData.id);
      return userData;
    } catch (error) {
      console.error('User creation error:', error);
      throw error;
    }
  }

  // JWT verification middleware
  async verifyJWT(req, res, next) {
    try {
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ 
          error: 'Missing or invalid authorization header',
          code: 'MISSING_TOKEN'
        });
      }

      const token = authHeader.substring(7);
      
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
      } catch (jwtError) {
        return res.status(401).json({
          error: 'Invalid or expired token',
          code: 'TOKEN_INVALID'
        });
      }
    } catch (error) {
      console.error('JWT verification middleware error:', error);
      res.status(500).json({ 
        error: 'Authentication verification failed',
        code: 'VERIFICATION_ERROR'
      });
    }
  }

  // Protected endpoint example
  async protectedEndpoint(req, res) {
    res.json({
      message: 'Access granted to protected resource',
      user: {
        id: req.user.sub,
        walletAddress: req.user.wallet_address,
        contractAuthorized: req.user.contract_authorized,
        tokenIssuedAt: new Date(req.user.iat * 1000).toISOString(),
        tokenExpiresAt: new Date(req.user.exp * 1000).toISOString()
      },
      timestamp: new Date().toISOString()
    });
  }

  // Get user profile
  async getUserProfile(req, res) {
    try {
      res.json({
        user: {
          id: req.user.sub,
          walletAddress: req.user.wallet_address,
          contractAuthorized: req.user.contract_authorized,
          tokenIssuedAt: new Date(req.user.iat * 1000).toISOString(),
          tokenExpiresAt: new Date(req.user.exp * 1000).toISOString()
        }
      });
    } catch (error) {
      console.error('Get profile error:', error);
      res.status(500).json({ 
        error: 'Failed to get user profile',
        code: 'PROFILE_ERROR'
      });
    }
  }

  // Token refresh
  async refreshToken(req, res) {
    try {
      const { refreshToken } = req.body;
      
      if (!refreshToken) {
        return res.status(401).json({
          error: 'Refresh token required',
          code: 'REFRESH_TOKEN_MISSING'
        });
      }

      try {
        const decoded = jwt.verify(refreshToken, process.env.JWT_SECRET);
        
        if (decoded.type !== 'refresh') {
          return res.status(401).json({
            error: 'Invalid refresh token',
            code: 'INVALID_REFRESH_TOKEN'
          });
        }

        // Generate new access token
        const newAccessToken = jwt.sign(
          {
            sub: decoded.sub,
            wallet_address: decoded.wallet_address,
            contract_authorized: true,
            iss: 'transparent-governance-platform',
            aud: process.env.FRONTEND_URL,
            iat: Math.floor(Date.now() / 1000),
            exp: Math.floor(Date.now() / 1000) + (24 * 60 * 60)
          },
          process.env.JWT_SECRET
        );

        res.json({
          accessToken: newAccessToken,
          expiresIn: 86400,
          tokenType: 'Bearer'
        });
      } catch (jwtError) {
        return res.status(401).json({
          error: 'Invalid or expired refresh token',
          code: 'REFRESH_TOKEN_INVALID'
        });
      }
    } catch (error) {
      console.error('Token refresh error:', error);
      res.status(500).json({ 
        error: 'Token refresh failed',
        code: 'REFRESH_ERROR'
      });
    }
  }

  // Logout
  async logout(req, res) {
    try {
      // In a production environment, you would:
      // 1. Invalidate the token in a blacklist
      // 2. Clear any cached user data
      // 3. Log the logout event
      
      res.json({
        success: true,
        message: 'Logged out successfully'
      });
    } catch (error) {
      console.error('Logout error:', error);
      res.status(500).json({ 
        error: 'Logout failed',
        code: 'LOGOUT_ERROR'
      });
    }
  }

  // Helper methods for challenge storage (use Redis in production)
  storeChallenge(walletAddress, challenge) {
    // In production, use Redis with TTL
    global.challenges = global.challenges || {};
    global.challenges[walletAddress.toLowerCase()] = challenge;
    
    // Clean up after 5 minutes
    setTimeout(() => {
      this.removeStoredChallenge(walletAddress);
    }, 5 * 60 * 1000);
  }

  getStoredChallenge(walletAddress) {
    global.challenges = global.challenges || {};
    return global.challenges[walletAddress.toLowerCase()];
  }

  removeStoredChallenge(walletAddress) {
    global.challenges = global.challenges || {};
    delete global.challenges[walletAddress.toLowerCase()];
  }
}

module.exports = Web3AuthService;
