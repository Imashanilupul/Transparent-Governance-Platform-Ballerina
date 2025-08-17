'use client';

import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { useAuthContext } from '@asgardeo/auth-react';
import { ethers } from 'ethers';
import { authServiceConfig } from '@/lib/auth-config';

interface Web3AuthContextType {
  // Wallet state
  isWalletConnected: boolean;
  walletAddress: string | null;
  
  // Auth service state
  isAuthServiceAuthenticated: boolean;
  authUser: any;
  accessToken: string | null;
  
  // Combined authentication state
  isFullyAuthenticated: boolean;
  
  // Actions
  connectWallet: () => Promise<void>;
  authenticateWithService: () => Promise<void>;
  logout: () => Promise<void>;
  
  // Loading states
  isLoading: boolean;
  error: string | null;
  
  // Helper methods
  makeAuthenticatedRequest: (url: string, options?: RequestInit) => Promise<any>;
}

const Web3AuthContext = createContext<Web3AuthContextType | null>(null);

export const useWeb3Auth = () => {
  const context = useContext(Web3AuthContext);
  if (!context) {
    throw new Error('useWeb3Auth must be used within Web3AuthProvider');
  }
  return context;
};

export const Web3AuthProvider: React.FC<{ children: React.ReactNode }> = ({ 
  children 
}) => {
  // Local state
  const [isWalletConnected, setIsWalletConnected] = useState(false);
  const [walletAddress, setWalletAddress] = useState<string | null>(null);
  const [isAuthServiceAuthenticated, setIsAuthServiceAuthenticated] = useState(false);
  const [authUser, setAuthUser] = useState<any>(null);
  const [accessToken, setAccessToken] = useState<string | null>(null);
  const [refreshToken, setRefreshToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Derived state
  const isFullyAuthenticated = isWalletConnected && isAuthServiceAuthenticated;

  // Load stored tokens on mount
  useEffect(() => {
    const storedAccessToken = sessionStorage.getItem('accessToken');
    const storedRefreshToken = sessionStorage.getItem('refreshToken');
    const storedUser = sessionStorage.getItem('authUser');

    if (storedAccessToken && storedUser) {
      setAccessToken(storedAccessToken);
      setRefreshToken(storedRefreshToken);
      setAuthUser(JSON.parse(storedUser));
      setIsAuthServiceAuthenticated(true);
      
      // If we have a user with wallet address, mark wallet as connected
      const user = JSON.parse(storedUser);
      if (user.walletAddress) {
        setWalletAddress(user.walletAddress);
        setIsWalletConnected(true);
      }
    }
  }, []);

  // Connect wallet and verify with smart contract
  const connectWallet = useCallback(async () => {
    try {
      setIsLoading(true);
      setError(null);

      if (!window.ethereum) {
        throw new Error('MetaMask not installed. Please install MetaMask to continue.');
      }

      const provider = new ethers.BrowserProvider(window.ethereum);
      const accounts = await provider.send("eth_requestAccounts", []);
      const signer = await provider.getSigner();
      const address = await signer.getAddress();

      // Step 1: Get challenge from backend
      const challengeResponse = await fetch(
        `${authServiceConfig.baseUrl}${authServiceConfig.endpoints.walletInitiate}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ walletAddress: address }),
        }
      );

      if (!challengeResponse.ok) {
        const errorData = await challengeResponse.json();
        throw new Error(errorData.error || 'Failed to get challenge from server');
      }

      const { challenge, nonce } = await challengeResponse.json();

      // Step 2: Sign challenge
      const signature = await signer.signMessage(challenge);

      // Step 3: Verify with backend (includes smart contract check)
      const verifyResponse = await fetch(
        `${authServiceConfig.baseUrl}${authServiceConfig.endpoints.walletVerify}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            walletAddress: address,
            signature,
            nonce,
          }),
        }
      );

      if (!verifyResponse.ok) {
        const errorData = await verifyResponse.json();
        throw new Error(errorData.error || 'Wallet verification failed');
      }

      const { authorized, tempToken } = await verifyResponse.json();

      if (!authorized) {
        throw new Error('Wallet not authorized by smart contract');
      }

      // Step 4: Exchange temp token for JWT
      const jwtResponse = await fetch(
        `${authServiceConfig.baseUrl}${authServiceConfig.endpoints.jwtExchange}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ tempToken }),
        }
      );

      if (!jwtResponse.ok) {
        const errorData = await jwtResponse.json();
        throw new Error(errorData.error || 'JWT exchange failed');
      }

      const { accessToken: newAccessToken, refreshToken: newRefreshToken, user } = await jwtResponse.json();

      // Store tokens and user data
      sessionStorage.setItem('accessToken', newAccessToken);
      sessionStorage.setItem('refreshToken', newRefreshToken);
      sessionStorage.setItem('authUser', JSON.stringify(user));

      setAccessToken(newAccessToken);
      setRefreshToken(newRefreshToken);
      setAuthUser(user);
      setWalletAddress(address);
      setIsWalletConnected(true);
      setIsAuthServiceAuthenticated(true);

      console.log('✅ Wallet connected and authenticated successfully');

    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error occurred');
      console.error('❌ Wallet connection error:', err);
    } finally {
      setIsLoading(false);
    }
  }, []);

  // Make authenticated requests with automatic token refresh
  const makeAuthenticatedRequest = useCallback(async (
    url: string,
    options: RequestInit = {}
  ) => {
    if (!accessToken) {
      throw new Error('No access token available');
    }

    const makeRequest = async (token: string) => {
      const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        ...options.headers,
      };

      const response = await fetch(url, {
        ...options,
        headers,
      });

      return response;
    };

    try {
      let response = await makeRequest(accessToken);

      // If token is expired, try to refresh
      if (response.status === 401 && refreshToken) {
        const refreshResponse = await fetch(
          `${authServiceConfig.baseUrl}${authServiceConfig.endpoints.refresh}`,
          {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ refreshToken }),
          }
        );

        if (refreshResponse.ok) {
          const { accessToken: newAccessToken } = await refreshResponse.json();
          
          // Update stored token
          sessionStorage.setItem('accessToken', newAccessToken);
          setAccessToken(newAccessToken);

          // Retry original request with new token
          response = await makeRequest(newAccessToken);
        } else {
          // Refresh failed, logout user
          await logout();
          throw new Error('Session expired, please login again');
        }
      }

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || `HTTP error! status: ${response.status}`);
      }

      return response.json();
    } catch (error) {
      console.error('Authenticated API request failed:', error);
      throw error;
    }
  }, [accessToken, refreshToken]);

  // Authenticate with service (already done in connectWallet, but kept for compatibility)
  const authenticateWithService = useCallback(async () => {
    if (!isWalletConnected) {
      throw new Error('Please connect your wallet first');
    }
    // This is now handled in connectWallet
  }, [isWalletConnected]);

  // Complete logout
  const logout = useCallback(async () => {
    try {
      setIsLoading(true);
      
      // Call logout endpoint if authenticated
      if (accessToken) {
        try {
          await fetch(`${authServiceConfig.baseUrl}${authServiceConfig.endpoints.logout}`, {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${accessToken}`,
              'Content-Type': 'application/json',
            },
          });
        } catch (logoutError) {
          console.warn('Logout endpoint call failed:', logoutError);
        }
      }

      // Clear all stored data
      sessionStorage.removeItem('accessToken');
      sessionStorage.removeItem('refreshToken');
      sessionStorage.removeItem('authUser');

      // Reset state
      setAccessToken(null);
      setRefreshToken(null);
      setAuthUser(null);
      setWalletAddress(null);
      setIsWalletConnected(false);
      setIsAuthServiceAuthenticated(false);
      setError(null);

      console.log('✅ Logged out successfully');

    } catch (err) {
      setError(err instanceof Error ? err.message : 'Logout failed');
      console.error('❌ Logout error:', err);
    } finally {
      setIsLoading(false);
    }
  }, [accessToken]);

  // Check for existing wallet connection on load
  useEffect(() => {
    const checkExistingConnection = async () => {
      if (window.ethereum && !isWalletConnected) {
        try {
          const accounts = await window.ethereum.request({
            method: 'eth_accounts'
          });
          
          if (accounts.length > 0 && !walletAddress) {
            // Don't auto-connect, just show that a wallet is available
            console.log('Wallet available but not connected to app');
          }
        } catch (err) {
          console.error('Error checking existing connection:', err);
        }
      }
    };

    checkExistingConnection();
  }, [isWalletConnected, walletAddress]);

  // Listen for account changes
  useEffect(() => {
    if (window.ethereum) {
      const handleAccountsChanged = (accounts: string[]) => {
        if (accounts.length === 0) {
          // User disconnected wallet
          logout();
        } else if (accounts[0] !== walletAddress) {
          // Account changed, need to re-authenticate
          logout();
        }
      };

      const handleChainChanged = (chainId: string) => {
        // Chain changed, reload the page or re-authenticate
        console.log('Chain changed to:', chainId);
        // For now, just logout on chain change
        logout();
      };

      window.ethereum.on('accountsChanged', handleAccountsChanged);
      window.ethereum.on('chainChanged', handleChainChanged);
      
      return () => {
        window.ethereum.removeListener('accountsChanged', handleAccountsChanged);
        window.ethereum.removeListener('chainChanged', handleChainChanged);
      };
    }
  }, [walletAddress, logout]);

  const value: Web3AuthContextType = {
    // Wallet state
    isWalletConnected,
    walletAddress,
    
    // Auth service state
    isAuthServiceAuthenticated,
    authUser,
    accessToken,
    
    // Combined state
    isFullyAuthenticated,
    
    // Actions
    connectWallet,
    authenticateWithService,
    logout,
    
    // UI state
    isLoading,
    error,
    
    // Helper methods
    makeAuthenticatedRequest,
  };

  return (
    <Web3AuthContext.Provider value={value}>
      {children}
    </Web3AuthContext.Provider>
  );
};

export default Web3AuthProvider;
