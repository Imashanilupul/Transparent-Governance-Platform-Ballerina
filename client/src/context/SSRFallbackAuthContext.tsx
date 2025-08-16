'use client'

import React, { createContext, useContext, ReactNode } from "react";

type SSRFallbackAuthState = {
  // Asgardeo authentication
  isAsgardeoAuthenticated: false;
  asgardeoUser: null;
  asgardeoLoading: true;
  
  // Wallet authentication  
  walletAddress: null;
  isWalletConnected: false;
  isWalletVerified: false;
  walletJwt: null;
  
  // Combined state
  isFullyAuthenticated: false;
  
  // SSR handling
  isClient: false;
};

type SSRFallbackAuthActions = {
  signIn: () => Promise<void>;
  signOut: () => Promise<void>;
  refreshAuth: () => Promise<void>;
};

type SSRFallbackAuthContextType = SSRFallbackAuthState & SSRFallbackAuthActions;

const SSRFallbackAuthContext = createContext<SSRFallbackAuthContextType>({
  // State
  isAsgardeoAuthenticated: false,
  asgardeoUser: null,
  asgardeoLoading: true,
  walletAddress: null,
  isWalletConnected: false,
  isWalletVerified: false,
  walletJwt: null,
  isFullyAuthenticated: false,
  isClient: false,
  
  // Actions
  signIn: async () => {},
  signOut: async () => {},
  refreshAuth: async () => {},
});

export function SSRFallbackAuthProvider({ children }: { children: ReactNode }) {
  const fallbackValue: SSRFallbackAuthContextType = {
    // State
    isAsgardeoAuthenticated: false,
    asgardeoUser: null,
    asgardeoLoading: true,
    walletAddress: null,
    isWalletConnected: false,
    isWalletVerified: false,
    walletJwt: null,
    isFullyAuthenticated: false,
    isClient: false,
    
    // Actions
    signIn: async () => {
      console.warn('signIn called during SSR - this should not happen');
    },
    signOut: async () => {
      console.warn('signOut called during SSR - this should not happen');
    },
    refreshAuth: async () => {
      console.warn('refreshAuth called during SSR - this should not happen');
    },
  };

  return (
    <SSRFallbackAuthContext.Provider value={fallbackValue}>
      {children}
    </SSRFallbackAuthContext.Provider>
  );
}

export function useSSRFallbackAuth() {
  return useContext(SSRFallbackAuthContext);
}
