'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { useAuthContext } from "@asgardeo/auth-react";
import { useAppKitAccount } from "@reown/appkit/react";
import axios from "axios";

type User = {
  id?: string;
  username?: string;
  email?: string;
  firstName?: string;
  lastName?: string;
  displayName?: string;
};

type AuthState = {
  // Asgardeo authentication
  isAsgardeoAuthenticated: boolean;
  asgardeoUser: User | null;
  asgardeoLoading: boolean;
  
  // Wallet authentication  
  walletAddress: string | null;
  isWalletConnected: boolean;
  isWalletVerified: boolean;
  walletJwt: string | null;
  
  // Combined state
  isFullyAuthenticated: boolean;
  
  // SSR handling
  isClient: boolean;
};

type AuthActions = {
  // Asgardeo actions
  signIn: () => Promise<void>;
  signOut: () => Promise<void>;
  
  // Combined actions
  refreshAuth: () => Promise<void>;
};

type AuthContextType = AuthState & AuthActions;

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function CombinedAuthProvider({ children }: { children: ReactNode }) {
  const [isClient, setIsClient] = useState(false);
  
  // Initialize client-side flag
  useEffect(() => {
    setIsClient(true);
  }, []);

  // Asgardeo auth - only available client-side
  const asgardeoAuth = useAuthContext();
  
  // Wallet auth - only available client-side  
  const walletAccount = useAppKitAccount();

  // Local state
  const [asgardeoUser, setAsgardeoUser] = useState<User | null>(null);
  const [isWalletVerified, setIsWalletVerified] = useState(false);
  const [walletJwt, setWalletJwt] = useState<string | null>(null);

  // Get user info when Asgardeo authentication changes
  useEffect(() => {
    if (!isClient) return;
    
    const fetchUserInfo = async () => {
      if (asgardeoAuth.state.isAuthenticated) {
        try {
          const userInfo = await asgardeoAuth.getBasicUserInfo();
          setAsgardeoUser({
            id: userInfo.sub,
            username: userInfo.preferred_username || userInfo.username,
            email: userInfo.email,
            firstName: userInfo.given_name,
            lastName: userInfo.family_name,
            displayName: userInfo.name || userInfo.preferred_username || userInfo.username
          });
        } catch (error) {
          console.error("Failed to fetch user info:", error);
          setAsgardeoUser(null);
        }
      } else {
        setAsgardeoUser(null);
      }
    };

    fetchUserInfo();
  }, [isClient, asgardeoAuth.state.isAuthenticated, asgardeoAuth.getBasicUserInfo]);

  // Check wallet verification when wallet connection changes
  useEffect(() => {
    if (!isClient) return;
    
    const checkWalletAuth = async () => {
      if (walletAccount.isConnected && walletAccount.address) {
        try {
          // Normalize address to lowercase for consistent authorization checks
          const normalizedAddress = walletAccount.address.toLowerCase();
          const res = await axios.get(`http://localhost:8080/api/auth/isauthorized/${normalizedAddress}`);
          setIsWalletVerified(res.data.verified);
          setWalletJwt(res.data.token || null);
        } catch (error) {
          console.error("Wallet auth check failed:", error);
          setIsWalletVerified(false);
          setWalletJwt(null);
        }
      } else {
        setIsWalletVerified(false);
        setWalletJwt(null);
      }
    };

    checkWalletAuth();
  }, [isClient, walletAccount.isConnected, walletAccount.address]);

  // Actions
  const signIn = async () => {
    if (!isClient) return;
    try {
      await asgardeoAuth.signIn();
    } catch (error) {
      console.error("Sign in failed:", error);
      throw error;
    }
  };

  const signOut = async () => {
    if (!isClient) return;
    try {
      await asgardeoAuth.signOut();
      // Also clear wallet state if needed
      setIsWalletVerified(false);
      setWalletJwt(null);
    } catch (error) {
      console.error("Sign out failed:", error);
      throw error;
    }
  };

  const refreshAuth = async () => {
    if (!isClient) return;
    
    // Refresh both Asgardeo and wallet authentication status
    if (asgardeoAuth.state.isAuthenticated) {
      try {
        const userInfo = await asgardeoAuth.getBasicUserInfo();
        setAsgardeoUser({
          id: userInfo.sub,
          username: userInfo.preferred_username || userInfo.username,
          email: userInfo.email,
          firstName: userInfo.given_name,
          lastName: userInfo.family_name,
          displayName: userInfo.name || userInfo.preferred_username || userInfo.username
        });
      } catch (error) {
        console.error("Failed to refresh user info:", error);
      }
    }

    if (walletAccount.isConnected && walletAccount.address) {
      try {
        const normalizedAddress = walletAccount.address.toLowerCase();
        const res = await axios.get(`http://localhost:8080/api/auth/isauthorized/${normalizedAddress}`);
        setIsWalletVerified(res.data.verified);
        setWalletJwt(res.data.token || null);
      } catch (error) {
        console.error("Failed to refresh wallet auth:", error);
      }
    }
  };

  // Combined authentication state
  const authState: AuthContextType = {
    // Asgardeo state
    isAsgardeoAuthenticated: isClient ? asgardeoAuth.state.isAuthenticated : false,
    asgardeoUser,
    asgardeoLoading: isClient ? asgardeoAuth.state.isLoading : true,
    
    // Wallet state
    walletAddress: isClient ? (walletAccount.address || null) : null,
    isWalletConnected: isClient ? walletAccount.isConnected : false,
    isWalletVerified,
    walletJwt,
    
    // Combined state - user is fully authenticated if they have both Asgardeo and verified wallet
    isFullyAuthenticated: isClient ? (asgardeoAuth.state.isAuthenticated && walletAccount.isConnected && isWalletVerified) : false,
    
    // SSR handling
    isClient,
    
    // Actions
    signIn,
    signOut,
    refreshAuth
  };

  return (
    <AuthContext.Provider value={authState}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    // Fallback for SSR or when used outside provider
    if (typeof window === 'undefined') {
      return {
        isAsgardeoAuthenticated: false,
        asgardeoUser: null,
        asgardeoLoading: true,
        walletAddress: null,
        isWalletConnected: false,
        isWalletVerified: false,
        walletJwt: null,
        isFullyAuthenticated: false,
        isClient: false,
        signIn: async () => {},
        signOut: async () => {},
        refreshAuth: async () => {},
      };
    }
    throw new Error('useAuth must be used within a CombinedAuthProvider');
  }
  return context;
}

// Legacy hook for backward compatibility
export function useLegacyAuth() {
  const { walletAddress, isWalletVerified, walletJwt } = useAuth();
  return {
    address: walletAddress,
    verified: isWalletVerified,
    jwt: walletJwt
  };
}
