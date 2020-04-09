#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
// プラグインメソッドを追加したい時にはここに `CAP_PLUGIN_METHOD` を追加する
CAP_PLUGIN(Sso, "Sso",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(signInWithGoogle, CAPPluginReturnPromise);
)
