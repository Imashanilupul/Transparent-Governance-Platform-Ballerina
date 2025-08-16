'use client'

import { useAuth } from '@/context/CombinedAuthContext';

export function AuthDebug() {
  const auth = useAuth();

  if (process.env.NODE_ENV !== 'development') {
    return null;
  }

  return (
    <div className="fixed bottom-4 left-4 bg-white border rounded-lg p-4 shadow-lg max-w-sm text-xs">
      <h3 className="font-bold mb-2">Auth Debug</h3>
      <div className="space-y-1">
        <div>Asgardeo Auth: {auth.isAsgardeoAuthenticated ? '✅' : '❌'}</div>
        <div>Wallet Connected: {auth.isWalletConnected ? '✅' : '❌'}</div>
        <div>Wallet Verified: {auth.isWalletVerified ? '✅' : '❌'}</div>
        <div>Fully Authenticated: {auth.isFullyAuthenticated ? '✅' : '❌'}</div>
        {auth.asgardeoUser && (
          <div>User: {auth.asgardeoUser.displayName}</div>
        )}
        {auth.walletAddress && (
          <div>Wallet: {auth.walletAddress.slice(0, 6)}...{auth.walletAddress.slice(-4)}</div>
        )}
      </div>
    </div>
  );
}
