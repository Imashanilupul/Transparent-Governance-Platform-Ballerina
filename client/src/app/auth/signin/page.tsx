'use client'

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/context/CombinedAuthContext';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

export default function SignInPage() {
  const router = useRouter();
  const { isAsgardeoAuthenticated, signIn, asgardeoLoading } = useAuth();

  useEffect(() => {
    if (isAsgardeoAuthenticated) {
      router.push('/');
    }
  }, [isAsgardeoAuthenticated, router]);

  const handleSignIn = async () => {
    try {
      await signIn();
    } catch (error) {
      console.error('Sign in failed:', error);
    }
  };

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

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl font-bold">Welcome</CardTitle>
          <CardDescription>
            Sign in to access the Transparent Governance Platform
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <Button 
            onClick={handleSignIn}
            className="w-full"
            size="lg"
          >
            Sign in with Asgardeo
          </Button>
          
          <div className="text-sm text-gray-500 text-center">
            <p>After signing in, you'll also need to connect your wallet</p>
            <p>to access blockchain features.</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
