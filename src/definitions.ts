declare module "@capacitor/core" {
  interface PluginRegistry {
    Sso: SsoPlugin;
  }
}

export interface GoogleSignInData {
  userId: number
  accessToken: string
  idToken: string
  refreshtoken: string
  token: string
  email?: string
  name?: string
  familyName?: string
  givenName?: string
  image?: string
}

export interface SsoPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  signInWithGoogle(options: { value: string }): Promise<{ data: GoogleSignInData }>;
}
