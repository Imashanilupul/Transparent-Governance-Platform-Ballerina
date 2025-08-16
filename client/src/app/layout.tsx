import type { Metadata } from "next"
import "../styles/globals.css"
import { SSRFallbackAuthProvider } from "@/context/SSRFallbackAuthContext"
import ClientLayout from "@/components/ClientLayout"

export const metadata: Metadata = {
  title: "Sri Lanka Transparent Governance Platform",
  description: "Created with v0",
  generator: "v0.dev",
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <body>
        <SSRFallbackAuthProvider>
          <ClientLayout>
            {children}
          </ClientLayout>
        </SSRFallbackAuthProvider>
      </body>
    </html>
  )
}
