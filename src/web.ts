import { WebPlugin } from '@capacitor/core';
import { SsoPlugin, GoogleSignInData } from './definitions';

export class SsoWeb extends WebPlugin implements SsoPlugin {
  constructor() {
    super({
      name: 'Sso',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
  async signInWithGoogle(): Promise<{ data: GoogleSignInData }> {
    return null;
  }
}

const Sso = new SsoWeb();

export { Sso };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(Sso);
