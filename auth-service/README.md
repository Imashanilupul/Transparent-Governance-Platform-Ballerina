# Web3 + JWT Authentication Service

A Node.js authentication service that combines Web3 wallet signatures with enterprise-grade JWT tokens, designed for the Transparent Governance Platform.

## Features

- 🔐 **Web3 Wallet Authentication**: MetaMask signature-based authentication
- 🏛️ **Smart Contract Integration**: Verify wallet authorization via smart contracts
- 🎫 **JWT Token Management**: Secure token issuance and validation
- 🔄 **Automatic Token Refresh**: Seamless token renewal
- 🛡️ **Security First**: Rate limiting, input validation, and secure headers
- 🏢 **Asgardeo Compatible**: Enterprise identity management integration

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web3 Wallet   │────│   Frontend App  │────│  Auth Service   │
│   (MetaMask)    │    │   (Next.js)     │    │   (Node.js)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                        ┌─────────────────┐
                        │  Smart Contract │
                        │   Validation    │
                        └─────────────────┘
```

## Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start the Service
```bash
# Development mode
npm run dev

# Production mode
npm start

# Using PowerShell script
./start-auth-service.ps1
```

## API Endpoints

### Authentication Flow

#### 1. Initiate Wallet Authentication
```http
POST /auth/wallet/initiate
Content-Type: application/json

{
  "walletAddress": "0x742d35CC6634C0532925a3b8D402B405F4032888"
}
```

#### 2. Verify Wallet and Contract
```http
POST /auth/wallet/verify
Content-Type: application/json

{
  "walletAddress": "0x742d35CC6634C0532925a3b8D402B405F4032888",
  "signature": "0x...",
  "nonce": "0x..."
}
```

#### 3. Exchange for JWT
```http
POST /auth/jwt/exchange
Content-Type: application/json

{
  "tempToken": "eyJ..."
}
```

### Protected Endpoints

#### Get User Profile
```http
GET /auth/profile
Authorization: Bearer <jwt_token>
```

#### Test Protected Resource
```http
GET /api/protected
Authorization: Bearer <jwt_token>
```

#### Refresh Token
```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJ..."
}
```

## Configuration

### Required Environment Variables

```env
# Server Configuration
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:3000

# Asgardeo Configuration
ASGARDEO_BASE_URL="https://api.asgardeo.io/t/razzallworks"
ASGARDEO_CLIENT_ID="your-client-id"
ASGARDEO_CLIENT_SECRET="your-client-secret"

# Blockchain Configuration
BLOCKCHAIN_RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY
CONTRACT_ADDRESS=0x...
CONTRACT_ABI='[...]'

# Security
JWT_SECRET=your-secure-jwt-secret-32-chars-min
TEMP_JWT_SECRET=your-temp-jwt-secret-32-chars-min
```

### Smart Contract Requirements

Your smart contract should implement an authorization check method:

```solidity
function isAuthorized(address user) external view returns (bool) {
    // Your authorization logic here
    return authorizedUsers[user];
}
```

## Security Features

- **Input Validation**: Comprehensive validation for all inputs
- **Rate Limiting**: Prevents brute force attacks
- **CORS Protection**: Configured for your frontend domain
- **Helmet Security**: Standard security headers
- **JWT Expiration**: Short-lived access tokens with refresh capability
- **Signature Verification**: Cryptographic proof of wallet ownership

## Development

### Running Tests
```bash
npm test
npm run test:watch
```

### Code Structure
```
src/
├── Web3AuthService.js    # Main authentication service
├── server.js            # Express server setup
└── ...
```

## Integration with Frontend

The service is designed to work with the Next.js frontend using the `Web3AuthProvider`:

```typescript
import { useWeb3Auth } from '@/providers/Web3AuthProvider';

function MyComponent() {
  const { connectWallet, isFullyAuthenticated } = useWeb3Auth();
  
  // Use authentication state and methods
}
```

## Production Deployment

### Recommended Setup
- Use Redis for challenge storage
- Set up proper logging and monitoring
- Configure SSL/TLS termination
- Use environment-specific secrets
- Set up health checks and auto-scaling

### Docker Support
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY src/ ./src/
EXPOSE 3001
CMD ["npm", "start"]
```

## Troubleshooting

### Common Issues

1. **Smart Contract Not Found**
   - Verify `CONTRACT_ADDRESS` and `CONTRACT_ABI` in `.env`
   - Check blockchain RPC connectivity

2. **JWT Verification Failed**
   - Ensure `JWT_SECRET` is consistent
   - Check token expiration

3. **CORS Errors**
   - Verify `FRONTEND_URL` matches your client domain
   - Check browser console for detailed errors

### Debug Mode
Set `NODE_ENV=development` for detailed error messages and logging.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is part of the Transparent Governance Platform and follows the main project's licensing terms.
