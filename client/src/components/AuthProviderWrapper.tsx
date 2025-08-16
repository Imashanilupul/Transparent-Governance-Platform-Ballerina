'use client'

import { AuthProvider as AsgardeoAuthProvider } from "@asgardeo/auth-react"
import { CombinedAuthProvider } from "@/context/CombinedAuthContext"
import authConfig from "@/config/asgardeo"
import { ReactNode } from "react"
import dynamic from "next/dynamic"

// Dynamically import ContextProvider to avoid SSR issues
const ContextProvider = dynamic(
  () => import("@/components/walletConnect/context"),
  { 
    ssr: false,
    loading: () => (
      <div className="flex items-center justify-center p-4">
        <div className="text-sm text-gray-600">Loading wallet connection...</div>
      </div>
    )
  }
)

interface AuthProviderWrapperProps {
  children: ReactNode
}

export default function AuthProviderWrapper({ children }: AuthProviderWrapperProps) {
  return (
    <AsgardeoAuthProvider config={authConfig}>
      <CombinedAuthProvider>
        <ContextProvider>
          {children}
        </ContextProvider>
      </CombinedAuthProvider>
    </AsgardeoAuthProvider>
  )
}
