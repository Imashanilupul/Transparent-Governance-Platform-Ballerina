import { AuthClientConfig } from '@asgardeo/auth-react';

export const asgardeoConfig: AuthClientConfig<any> = {
  signInRedirectURL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
  signOutRedirectURL: process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000',
  clientID: process.env.NEXT_PUBLIC_ASGARDEO_CLIENT_ID || 'fltg4uoj2AgN8PibtkuNtfMDeXEa',
  baseUrl: process.env.NEXT_PUBLIC_ASGARDEO_BASE_URL || 'https://api.asgardeo.io/t/razzallworks',
  scope: ['openid', 'profile'],
  resourceServerURLs: [process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001'],
  storage: 'sessionStorage',
  enablePKCE: true,
  validateIDToken: true,
  clockTolerance: 300,
};

export const authServiceConfig = {
  baseUrl: process.env.NEXT_PUBLIC_AUTH_SERVICE_URL || 'http://localhost:3002',
  endpoints: {
    walletInitiate: '/auth/wallet/initiate',
    walletVerify: '/auth/wallet/verify',
    jwtExchange: '/auth/jwt/exchange',
    jwtVerify: '/auth/jwt/verify',
    refresh: '/auth/refresh',
    profile: '/auth/profile',
    logout: '/auth/logout',
    protected: '/api/protected'
  }
};
