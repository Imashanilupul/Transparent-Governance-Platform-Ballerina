'use client';

import React, { useState } from 'react';
import { useWeb3Auth } from '@/providers/Web3AuthProvider';
import { useAuthenticatedApi } from '@/hooks/useAuthenticatedApi';
import Web3LoginCard from '@/components/Web3LoginCard';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { RefreshCw, User, Shield, Key, Globe } from 'lucide-react';

export default function Web3AuthDemo() {
  const { isFullyAuthenticated, authUser, walletAddress, accessToken } = useWeb3Auth();
  const { api, isAuthenticated } = useAuthenticatedApi();
  
  const [testResult, setTestResult] = useState<any>(null);
  const [isTestLoading, setIsTestLoading] = useState(false);
  const [userProfile, setUserProfile] = useState<any>(null);

  const testProtectedEndpoint = async () => {
    if (!isAuthenticated) return;
    
    setIsTestLoading(true);
    try {
      const result = await api.get('http://localhost:3002/api/protected');
      setTestResult(result);
    } catch (error) {
      setTestResult({ error: error instanceof Error ? error.message : 'Unknown error' });
    } finally {
      setIsTestLoading(false);
    }
  };

  const getUserProfile = async () => {
    if (!isAuthenticated) return;
    
    setIsTestLoading(true);
    try {
      const profile = await api.get('http://localhost:3002/auth/profile');
      setUserProfile(profile);
    } catch (error) {
      setUserProfile({ error: error instanceof Error ? error.message : 'Unknown error' });
    } finally {
      setIsTestLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 p-4">
      <div className="max-w-6xl mx-auto space-y-6">
        {/* Header */}
        <div className="text-center py-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            Web3 + JWT Authentication Demo
          </h1>
          <p className="text-gray-600 max-w-2xl mx-auto">
            Secure authentication combining Web3 wallet signatures with enterprise-grade JWT tokens 
            through Asgardeo integration for the Transparent Governance Platform.
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          {/* Authentication Card */}
          <div className="space-y-4">
            <Web3LoginCard />
            
            {/* Authentication Status */}
            {isFullyAuthenticated && (
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <User className="h-5 w-5" />
                    <span>Authentication Status</span>
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="flex items-center space-x-2">
                      <Shield className="h-4 w-4 text-green-500" />
                      <span className="text-sm">Wallet Connected</span>
                    </span>
                    <Badge variant="secondary" className="bg-green-100 text-green-700">
                      ✓ Verified
                    </Badge>
                  </div>
                  
                  <div className="flex items-center justify-between">
                    <span className="flex items-center space-x-2">
                      <Key className="h-4 w-4 text-blue-500" />
                      <span className="text-sm">JWT Token</span>
                    </span>
                    <Badge variant="secondary" className="bg-blue-100 text-blue-700">
                      ✓ Active
                    </Badge>
                  </div>

                  <div className="flex items-center justify-between">
                    <span className="flex items-center space-x-2">
                      <Globe className="h-4 w-4 text-purple-500" />
                      <span className="text-sm">Smart Contract</span>
                    </span>
                    <Badge variant="secondary" className="bg-purple-100 text-purple-700">
                      ✓ Authorized
                    </Badge>
                  </div>

                  <div className="pt-2 border-t">
                    <div className="text-xs text-gray-600 space-y-1">
                      <div>Wallet: <span className="font-mono">{walletAddress?.slice(0, 10)}...{walletAddress?.slice(-8)}</span></div>
                      <div>User ID: <span className="font-mono">{authUser?.id}</span></div>
                      <div>Token: <span className="font-mono">{accessToken?.slice(0, 20)}...</span></div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>

          {/* API Testing */}
          <div className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle>API Testing</CardTitle>
                <CardDescription>
                  Test authenticated API endpoints with your JWT token
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                {!isAuthenticated ? (
                  <Alert>
                    <AlertDescription>
                      Please authenticate first to test API endpoints
                    </AlertDescription>
                  </Alert>
                ) : (
                  <div className="space-y-3">
                    <Button
                      onClick={testProtectedEndpoint}
                      disabled={isTestLoading}
                      className="w-full"
                      variant="outline"
                    >
                      {isTestLoading ? (
                        <RefreshCw className="h-4 w-4 animate-spin mr-2" />
                      ) : null}
                      Test Protected Endpoint
                    </Button>

                    <Button
                      onClick={getUserProfile}
                      disabled={isTestLoading}
                      className="w-full"
                      variant="outline"
                    >
                      {isTestLoading ? (
                        <RefreshCw className="h-4 w-4 animate-spin mr-2" />
                      ) : null}
                      Get User Profile
                    </Button>
                  </div>
                )}

                {/* Test Results */}
                {(testResult || userProfile) && (
                  <div className="space-y-3">
                    {testResult && (
                      <div>
                        <h4 className="font-medium text-sm mb-2">Protected Endpoint Response:</h4>
                        <pre className="bg-gray-100 p-3 rounded text-xs overflow-auto max-h-40">
                          {JSON.stringify(testResult, null, 2)}
                        </pre>
                      </div>
                    )}

                    {userProfile && (
                      <div>
                        <h4 className="font-medium text-sm mb-2">User Profile Response:</h4>
                        <pre className="bg-gray-100 p-3 rounded text-xs overflow-auto max-h-40">
                          {JSON.stringify(userProfile, null, 2)}
                        </pre>
                      </div>
                    )}
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Architecture Info */}
            <Card>
              <CardHeader>
                <CardTitle className="text-lg">Architecture Overview</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm">
                  <div className="flex items-start space-x-3">
                    <div className="w-6 h-6 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                      <span className="text-blue-600 text-xs font-bold">1</span>
                    </div>
                    <div>
                      <p className="font-medium">Wallet Connection</p>
                      <p className="text-gray-600">MetaMask signs a challenge message</p>
                    </div>
                  </div>

                  <div className="flex items-start space-x-3">
                    <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                      <span className="text-green-600 text-xs font-bold">2</span>
                    </div>
                    <div>
                      <p className="font-medium">Smart Contract Verification</p>
                      <p className="text-gray-600">Backend verifies wallet authorization</p>
                    </div>
                  </div>

                  <div className="flex items-start space-x-3">
                    <div className="w-6 h-6 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                      <span className="text-purple-600 text-xs font-bold">3</span>
                    </div>
                    <div>
                      <p className="font-medium">JWT Token Issuance</p>
                      <p className="text-gray-600">Asgardeo-compatible JWT with user claims</p>
                    </div>
                  </div>

                  <div className="flex items-start space-x-3">
                    <div className="w-6 h-6 bg-orange-100 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                      <span className="text-orange-600 text-xs font-bold">4</span>
                    </div>
                    <div>
                      <p className="font-medium">Authenticated Requests</p>
                      <p className="text-gray-600">Automatic token refresh and validation</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center py-6 text-gray-500 text-sm">
          <p>🔐 Secure • 🌐 Decentralized • ⚡ Enterprise-Ready</p>
          <p className="mt-1">Transparent Governance Platform - Web3 Authentication System</p>
        </div>
      </div>
    </div>
  );
}
