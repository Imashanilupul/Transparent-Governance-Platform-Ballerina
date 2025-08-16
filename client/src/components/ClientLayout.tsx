'use client'

import { Toaster } from "sonner"
import { ReactNode, useEffect, useState } from "react"
import dynamic from "next/dynamic"

// Dynamically import all authentication components to avoid SSR issues
const AuthProviderWrapper = dynamic(
  () => import("./AuthProviderWrapper"),
  { 
    ssr: false,
    loading: () => (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900 mx-auto mb-2"></div>
          <div>Loading authentication...</div>
        </div>
      </div>
    )
  }
)

interface ClientLayoutProps {
  children: ReactNode
}

export default function ClientLayout({ children }: ClientLayoutProps) {
  const [isMounted, setIsMounted] = useState(false)

  useEffect(() => {
    setIsMounted(true)
  }, [])

  if (!isMounted) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900 mx-auto mb-2"></div>
          <div>Initializing...</div>
        </div>
      </div>
    )
  }

  return (
    <>
      <AuthProviderWrapper>
        {children}
      </AuthProviderWrapper>
      <Toaster 
        position="top-right" 
        toastOptions={{
          style: {
            background: 'white',
            border: '1px solid #e2e8f0',
            color: '#0f172a',
          },
        }}
      />
    </>
  )
}
