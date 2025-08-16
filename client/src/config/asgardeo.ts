import { AuthReactConfig } from "@asgardeo/auth-react";

const baseUrl = process.env.NEXT_PUBLIC_ASGARDEO_BASE_URL || "";

// Helper function to get origin safely during SSR
const getOrigin = () => {
  if (typeof window !== 'undefined') {
    return window.location.origin;
  }
  // Fallback for SSR
  return process.env.NEXT_PUBLIC_APP_URL || "http://localhost:3000";
};

export const authConfig: AuthReactConfig = {
  signInRedirectURL: `${getOrigin()}/auth/callback`,
  signOutRedirectURL: getOrigin(),
  clientID: process.env.NEXT_PUBLIC_ASGARDEO_CLIENT_ID || "",
  baseUrl: baseUrl,
  scope: process.env.NEXT_PUBLIC_ASGARDEO_SCOPES?.split(" ") || ["openid", "profile"],
  resourceServerURLs: [
    process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080"
  ],
  storage: "webWorker" as const,
  endpoints: {
    authorizationEndpoint: `${baseUrl}/oauth2/authorize`,
    tokenEndpoint: `${baseUrl}/oauth2/token`,
    userinfoEndpoint: `${baseUrl}/oauth2/userinfo`,
    jwksUri: `${baseUrl}/oauth2/jwks`,
    registrationEndpoint: `${baseUrl}/oauth2/register`,
    revocationEndpoint: `${baseUrl}/oauth2/revoke`,
    introspectionEndpoint: `${baseUrl}/oauth2/introspect`,
    checkSessionIframe: `${baseUrl}/oidc/checksession`,
    endSessionEndpoint: `${baseUrl}/oidc/logout`,
    issuer: baseUrl
  }
};

export default authConfig;
