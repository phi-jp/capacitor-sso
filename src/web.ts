import { WebPlugin } from '@capacitor/core';
import { SsoPlugin } from './definitions';

export class SsoWeb extends WebPlugin implements SsoPlugin {
  constructor() {
    super({
      name: 'Sso',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const Sso = new SsoWeb();

export { Sso };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(Sso);
