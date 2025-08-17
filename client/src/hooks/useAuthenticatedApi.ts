import { useCallback } from 'react';
import { useWeb3Auth } from '@/providers/Web3AuthProvider';

export const useAuthenticatedApi = () => {
  const { makeAuthenticatedRequest, isFullyAuthenticated } = useWeb3Auth();

  const api = useCallback(() => ({
    // GET request
    get: async (url: string, options: RequestInit = {}) => {
      return makeAuthenticatedRequest(url, {
        ...options,
        method: 'GET',
      });
    },

    // POST request
    post: async (url: string, data?: any, options: RequestInit = {}) => {
      return makeAuthenticatedRequest(url, {
        ...options,
        method: 'POST',
        body: data ? JSON.stringify(data) : undefined,
      });
    },

    // PUT request
    put: async (url: string, data?: any, options: RequestInit = {}) => {
      return makeAuthenticatedRequest(url, {
        ...options,
        method: 'PUT',
        body: data ? JSON.stringify(data) : undefined,
      });
    },

    // DELETE request
    delete: async (url: string, options: RequestInit = {}) => {
      return makeAuthenticatedRequest(url, {
        ...options,
        method: 'DELETE',
      });
    },

    // PATCH request
    patch: async (url: string, data?: any, options: RequestInit = {}) => {
      return makeAuthenticatedRequest(url, {
        ...options,
        method: 'PATCH',
        body: data ? JSON.stringify(data) : undefined,
      });
    },
  }), [makeAuthenticatedRequest]);

  return { 
    api: api(), 
    isAuthenticated: isFullyAuthenticated,
    makeAuthenticatedRequest 
  };
};

export default useAuthenticatedApi;
