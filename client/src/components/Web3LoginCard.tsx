'use client';

import React from 'react';
import { useWeb3Auth } from '@/providers/Web3AuthProvider';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { AlertCircle, CheckCircle, Wallet, Shield, Key } from 'lucide-react';
import { Alert, AlertDescription } from '@/components/ui/alert';

export const Web3LoginCard: React.FC = () => {
  const {
    isWalletConnected,
    walletAddress,
    isAuthServiceAuthenticated,
    isFullyAuthenticated,
    connectWallet,
    logout,
    isLoading,
    error,
    authUser,
  } = useWeb3Auth();

  if (isFullyAuthenticated) {
    return (
      <Card className="w-full max-w-md mx-auto">
        <CardHeader className="text-center">
          <div className="flex justify-center mb-2">
            <CheckCircle className="h-12 w-12 text-green-500" />
          </div>
          <CardTitle className="text-green-700">✅ Authenticated</CardTitle>
          <CardDescription>Successfully connected and verified</CardDescription>
        </CardHeader>
        
        <CardContent className="space-y-4">
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">Wallet:</span>
              <span className="font-mono text-xs">
                {walletAddress?.slice(0, 6)}...{walletAddress?.slice(-4)}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">User ID:</span>
              <span className="font-mono text-xs">{authUser?.id}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Status:</span>
              <span className="text-green-600 font-medium">Authorized</span>
            </div>
          </div>
          
          <Button
            onClick={logout}
            variant="outline"
            className="w-full"
            disabled={isLoading}
          >
            {isLoading ? 'Logging out...' : 'Logout'}
          </Button>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader className="text-center">
        <div className="flex justify-center mb-2">
          <Shield className="h-12 w-12 text-blue-500" />
        </div>
        <CardTitle>Web3 Authentication</CardTitle>
        <CardDescription>
          Connect your wallet and verify with smart contract
        </CardDescription>
      </CardHeader>
      
      <CardContent className="space-y-4">
        {error && (
          <Alert variant="destructive">
            <AlertCircle className="h-4 w-4" />
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        )}

        <div className="space-y-3">
          {/* Step 1: Wallet Connection */}
          <div className="flex items-center justify-between p-3 border rounded-lg">
            <div className="flex items-center space-x-3">
              <div className={`p-2 rounded-full ${
                isWalletConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
              }`}>
                <Wallet className="h-4 w-4" />
              </div>
              <div>
                <h3 className="font-medium text-sm">Connect Wallet</h3>
                <p className="text-xs text-gray-600">
                  {isWalletConnected 
                    ? `${walletAddress?.slice(0, 8)}...${walletAddress?.slice(-6)}`
                    : 'MetaMask wallet required'
                  }
                </p>
              </div>
            </div>
            <div className={`w-3 h-3 rounded-full ${
              isWalletConnected ? 'bg-green-500' : 'bg-gray-300'
            }`} />
          </div>

          {/* Step 2: Smart Contract Verification */}
          <div className="flex items-center justify-between p-3 border rounded-lg">
            <div className="flex items-center space-x-3">
              <div className={`p-2 rounded-full ${
                isAuthServiceAuthenticated ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
              }`}>
                <Key className="h-4 w-4" />
              </div>
              <div>
                <h3 className="font-medium text-sm">Verify Authorization</h3>
                <p className="text-xs text-gray-600">
                  {isAuthServiceAuthenticated
                    ? 'Contract verified & JWT issued'
                    : 'Smart contract authorization pending'
                  }
                </p>
              </div>
            </div>
            <div className={`w-3 h-3 rounded-full ${
              isAuthServiceAuthenticated ? 'bg-green-500' : 'bg-gray-300'
            }`} />
          </div>
        </div>

        <Button
          onClick={connectWallet}
          disabled={isLoading || isFullyAuthenticated}
          className="w-full"
          size="lg"
        >
          {isLoading ? (
            <div className="flex items-center space-x-2">
              <div className="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent" />
              <span>Connecting...</span>
            </div>
          ) : isFullyAuthenticated ? (
            'Connected'
          ) : (
            'Connect & Authenticate'
          )}
        </Button>

        <div className="text-xs text-gray-500 text-center space-y-1">
          <p>By connecting, you agree to sign a message to verify wallet ownership.</p>
          <p>No gas fees or blockchain transactions required.</p>
        </div>
      </CardContent>
    </Card>
  );
};

export default Web3LoginCard;
