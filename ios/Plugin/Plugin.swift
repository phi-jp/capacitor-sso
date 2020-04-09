import Foundation
import Capacitor
import GoogleSignIn


@objc(Sso)
public class Sso: CAPPlugin {
    let googleSignIn: GIDSignIn = GIDSignIn.sharedInstance();
    
    override public func load() {
        let googleClientId = getConfigValue("googleClientId") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        
        self.googleSignIn.clientID = googleClientId
        self.googleSignIn.delegate = self as? GIDSignInDelegate
        self.googleSignIn.presentingViewController = bridge.viewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyFromAppDelegate(notification:)), name: Notification.Name(CAPNotifications.URLOpen.name()), object: nil);
    }
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    @objc func notifyFromAppDelegate(notification: Notification) {
        guard  let object = notification.object as? [String:Any],
            let url = object["url"] as? URL else { return }
    
        let isFromTwitter = url.absoluteString.contains("twitterkit")
        let isFromLine = url.absoluteString.contains("line3rdp")
        let isFromGoogle = url.absoluteString.contains("com.googleusercontent")
        let isFromFacebook = url.absoluteString.prefix(2) == "fb"
        
        var options:[UIApplication.OpenURLOptionsKey:Any] = [:]
        
        var sourceApplication: String
        if let sa = object["sourceApplication"] as? String {
            sourceApplication = sa
        } else {
            sourceApplication = ""
        }
        options[UIApplication.OpenURLOptionsKey.sourceApplication] = sourceApplication
        
        let an = object["annotation"]
        if an != nil {
            options[UIApplication.OpenURLOptionsKey.openInPlace] = an
        } else {
            options[UIApplication.OpenURLOptionsKey.openInPlace] = 0
        }
        
        // twitter 用
//        if isFromTwitter {
//            if (sourceApplication == "") {
//                options[UIApplication.OpenURLOptionsKey.sourceApplication] = "com.twitter"
//            }
//            TWTRTwitter().application(UIApplication.shared,
//                                      open: url,
//                                      options: options)
//        }
//
//        // line 用
//        if isFromLine {
//            _ = LoginManager.shared.application(UIApplication.shared, open: url, options: options)
//        }
//
//        // facebook 用
//        if isFromFacebook {
//            ApplicationDelegate.shared.application(UIApplication.shared,
//                                                   open: url,
//                                                   sourceApplication: sourceApplication,
//                                                   annotation: options[UIApplication.OpenURLOptionsKey.openInPlace])
//        }
        
    }
}
