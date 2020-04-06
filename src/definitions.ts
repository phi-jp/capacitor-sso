declare module "@capacitor/core" {
  interface PluginRegistry {
    Sso: SsoPlugin;
  }
}

export interface SsoPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
}
