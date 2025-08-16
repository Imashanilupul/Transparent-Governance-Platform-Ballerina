'use client'

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuthContext } from '@asgardeo/auth-react';

export default function AuthCallbackPage() {
  const router = useRouter();
  const { state } = useAuthContext();

  useEffect(() => {
    if (state.isAuthenticated) {
      // Redirect to dashboard or home page after successful authentication
      router.push('/');
    } else if (!state.isLoading) {
      // If not authenticated and not loading, redirect to sign in
      router.push('/auth/signin');
    }
  }, [state.isAuthenticated, state.isLoading, router]);

  if (state.isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Completing authentication...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <p className="text-gray-600">Redirecting...</p>
      </div>
    </div>
  );
}
