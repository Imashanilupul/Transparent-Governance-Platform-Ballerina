# Asgardeo Authentication Integration

This document describes the integration of Asgardeo authentication into the Transparent Governance Platform.

## Overview

The platform now uses a hybrid authentication system:
1. **Asgardeo OAuth2/OIDC** for user identity management
2. **Wallet-based authentication** for blockchain interactions
3. **Combined authentication** for full platform access

## Environment Configuration

The following environment variables have been added to `.env.local`:

```bash
# Asgardeo Authentication Configuration
NEXT_PUBLIC_ASGARDEO_BASE_URL="https://api.asgardeo.io/t/razzallworks"
NEXT_PUBLIC_ASGARDEO_CLIENT_ID="fltg4uoj2AgN8PibtkuNtfMDeXEa"
ASGARDEO_CLIENT_SECRET="PaiCFb61dG8DBQPuX6G9ntmG3ppbalFIhB_npQIJZQsa"
NEXT_PUBLIC_ASGARDEO_SCOPES="openid profile"
```

## Key Components Added

### 1. Authentication Configuration (`src/config/asgardeo.ts`)
- Asgardeo client configuration with all required endpoints
- Environment-based configuration

### 2. Combined Authentication Context (`src/context/CombinedAuthContext.tsx`)
- Manages both Asgardeo and wallet authentication states
- Provides a unified interface for authentication status
- Backward compatibility with existing wallet-only code

### 3. Authentication Pages
- **Sign In**: `/auth/signin` - Asgardeo OAuth2 login
- **Callback**: `/auth/callback` - OAuth2 callback handler

### 4. Protected Components
- **ProtectedRoute**: Wrapper for pages requiring authentication
- **AuthStatus**: Shows current authentication status
- **AuthDebug**: Development-only debug component

## Authentication Flow

1. **User visits the platform**
   - Shows "Sign In" button if not authenticated
   - Displays AuthStatus component if authenticated

2. **Asgardeo Sign In**
   - Redirects to Asgardeo OAuth2 authorization endpoint
   - User authenticates with Asgardeo
   - Returns to `/auth/callback` with authorization code
   - Exchange code for tokens and user info

3. **Wallet Connection (Optional)**
   - User can connect MetaMask or other wallets
   - Wallet verification through smart contracts
   - Required for blockchain features (reports, petitions)

4. **Full Authentication**
   - Combination of Asgardeo + verified wallet
   - Enables all platform features

## Usage Examples

### Basic Authentication Check
```tsx
import { useAuth } from '@/context/CombinedAuthContext';

function MyComponent() {
  const { isAsgardeoAuthenticated, asgardeoUser } = useAuth();
  
  if (!isAsgardeoAuthenticated) {
    return <div>Please sign in</div>;
  }
  
  return <div>Welcome, {asgardeoUser?.displayName}</div>;
}
```

### Wallet-Specific Features
```tsx
import { useAuth } from '@/context/CombinedAuthContext';

function WalletComponent() {
  const { isWalletConnected, isWalletVerified, walletAddress } = useAuth();
  
  if (!isWalletConnected) {
    return <div>Connect your wallet</div>;
  }
  
  if (!isWalletVerified) {
    return <div>Wallet verification required</div>;
  }
  
  return <div>Wallet ready: {walletAddress}</div>;
}
```

### Legacy Compatibility
```tsx
import { useLegacyAuth } from '@/context/CombinedAuthContext';

function LegacyComponent() {
  const { address, verified } = useLegacyAuth();
  // Same interface as before
}
```

## Dependencies Added

```json
{
  "@asgardeo/auth-react": "^6.x.x",
  "@asgardeo/auth-spa": "^4.x.x"
}
```

## Asgardeo Application Configuration

In your Asgardeo console, ensure:

1. **Application Type**: Single Page Application (SPA)
2. **Grant Types**: Authorization Code
3. **Callback URLs**: 
   - `http://localhost:3000/auth/callback` (development)
   - Your production domain callback URL
4. **Logout URLs**:
   - `http://localhost:3000` (development)
   - Your production domain
5. **Scopes**: `openid profile`

## Security Considerations

1. **Client Secret**: Store securely, never expose in frontend code
2. **Redirect URLs**: Validate strictly in Asgardeo console
3. **Token Storage**: Uses secure web worker storage
4. **HTTPS**: Required for production

## Testing

1. Start the development servers:
   ```bash
   # Terminal 1: Smart contracts service
   cd smart-contracts
   node scripts/app.js
   
   # Terminal 2: Ballerina backend
   cd server
   bal run
   
   # Terminal 3: Next.js frontend
   cd client
   npm run dev
   ```

2. Visit `http://localhost:3000`
3. Click "Sign In" to test Asgardeo authentication
4. Connect wallet for full platform access

## Troubleshooting

### Common Issues

1. **CORS Errors**: Check Asgardeo application configuration
2. **Redirect Loops**: Verify callback URLs match exactly
3. **Token Errors**: Check client ID and secret configuration
4. **Wallet Issues**: Ensure smart contracts service is running

### Debug Information

In development mode, the AuthDebug component shows:
- Asgardeo authentication status
- Wallet connection status
- User information
- Current authentication state

## Next Steps

1. **User Registration**: Implement user profile management
2. **Role-Based Access**: Add role-based permissions
3. **Multi-Factor Auth**: Enhance security with MFA
4. **Session Management**: Implement proper session handling
5. **Audit Logging**: Track authentication events
