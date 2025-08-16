'use client'

import { useAuth } from '@/context/CombinedAuthContext';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireWallet?: boolean;
  requireFullAuth?: boolean;
}

export function ProtectedRoute({ 
  children, 
  requireWallet = false, 
  requireFullAuth = false 
}: ProtectedRouteProps) {
  const router = useRouter();
  const { 
    isAsgardeoAuthenticated, 
    isWalletConnected, 
    isWalletVerified, 
    isFullyAuthenticated,
    asgardeoLoading 
  } = useAuth();

  useEffect(() => {
    if (asgardeoLoading) return; // Wait for auth to load

    // Check authentication requirements
    if (!isAsgardeoAuthenticated) {
      router.push('/auth/signin');
      return;
    }

    if (requireWallet && !isWalletConnected) {
      // Could redirect to a page that prompts for wallet connection
      console.warn('Wallet connection required but not connected');
    }

    if (requireFullAuth && !isFullyAuthenticated) {
      // Could redirect to a page that shows authentication status
      console.warn('Full authentication required but not completed');
    }
  }, [
    isAsgardeoAuthenticated, 
    isWalletConnected, 
    isWalletVerified, 
    isFullyAuthenticated,
    asgardeoLoading,
    requireWallet, 
    requireFullAuth, 
    router
  ]);

  if (asgardeoLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }

  if (!isAsgardeoAuthenticated) {
    return null; // Will redirect to sign in
  }

  return <>{children}</>;
}
