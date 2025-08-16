'use client'

import { useAuth } from '@/context/CombinedAuthContext';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { CheckCircle, AlertCircle, User, Wallet, LogOut } from 'lucide-react';

export function AuthStatus() {
  const { 
    isAsgardeoAuthenticated,
    asgardeoUser,
    isWalletConnected,
    isWalletVerified,
    walletAddress,
    isFullyAuthenticated,
    signOut
  } = useAuth();

  const handleSignOut = async () => {
    try {
      await signOut();
    } catch (error) {
      console.error('Sign out failed:', error);
    }
  };

  if (!isAsgardeoAuthenticated) {
    return null;
  }

  return (
    <Card className="max-w-md">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <User className="h-5 w-5" />
          Authentication Status
        </CardTitle>
        <CardDescription>
          Your current authentication and wallet connection status
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Asgardeo Authentication Status */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CheckCircle className="h-4 w-4 text-green-600" />
            <span className="text-sm">Asgardeo Account</span>
          </div>
          <Badge variant="secondary" className="bg-green-100 text-green-800">
            Connected
          </Badge>
        </div>
        
        {asgardeoUser && (
          <div className="text-sm text-gray-600 ml-6">
            <p>Welcome, {asgardeoUser.displayName || asgardeoUser.username}</p>
            {asgardeoUser.email && <p className="text-xs">{asgardeoUser.email}</p>}
          </div>
        )}

        {/* Wallet Connection Status */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Wallet className="h-4 w-4" />
            <span className="text-sm">Wallet Connection</span>
          </div>
          <Badge 
            variant="secondary" 
            className={isWalletConnected 
              ? "bg-green-100 text-green-800" 
              : "bg-gray-100 text-gray-800"
            }
          >
            {isWalletConnected ? 'Connected' : 'Not Connected'}
          </Badge>
        </div>

        {walletAddress && (
          <div className="text-xs text-gray-600 ml-6 font-mono">
            {walletAddress.slice(0, 6)}...{walletAddress.slice(-4)}
          </div>
        )}

        {/* Wallet Verification Status */}
        {isWalletConnected && (
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              {isWalletVerified ? (
                <CheckCircle className="h-4 w-4 text-green-600" />
              ) : (
                <AlertCircle className="h-4 w-4 text-yellow-600" />
              )}
              <span className="text-sm">Wallet Verification</span>
            </div>
            <Badge 
              variant="secondary" 
              className={isWalletVerified 
                ? "bg-green-100 text-green-800" 
                : "bg-yellow-100 text-yellow-800"
              }
            >
              {isWalletVerified ? 'Verified' : 'Pending'}
            </Badge>
          </div>
        )}

        {/* Full Authentication Status */}
        <div className="border-t pt-4">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium">Full Access</span>
            <Badge 
              variant="secondary" 
              className={isFullyAuthenticated 
                ? "bg-green-100 text-green-800" 
                : "bg-yellow-100 text-yellow-800"
              }
            >
              {isFullyAuthenticated ? 'Ready' : 'Incomplete'}
            </Badge>
          </div>
          
          {!isFullyAuthenticated && (
            <p className="text-xs text-gray-600 mt-2">
              {!isWalletConnected 
                ? "Connect your wallet to access blockchain features"
                : !isWalletVerified 
                ? "Your wallet needs verification to submit reports and create petitions"
                : "Authentication complete"
              }
            </p>
          )}
        </div>

        {/* Sign Out Button */}
        <Button 
          onClick={handleSignOut}
          variant="outline" 
          size="sm"
          className="w-full mt-4"
        >
          <LogOut className="h-4 w-4 mr-2" />
          Sign Out
        </Button>
      </CardContent>
    </Card>
  );
}
