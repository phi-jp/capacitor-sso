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
}
