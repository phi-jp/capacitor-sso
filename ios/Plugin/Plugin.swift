import Foundation
import Capacitor
import GoogleSignIn


@objc(Sso)
public class Sso: CAPPlugin {
    var signInCall: CAPPluginCall?
    let googleSignIn: GIDSignIn = GIDSignIn.sharedInstance();
    
    // initialize 初期化時に呼ばれる
    override public func load() {
        let googleClientId = getConfigValue("googleClientId") as? String ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        
        self.googleSignIn.clientID = googleClientId
        self.googleSignIn.delegate = self as? GIDSignInDelegate
        self.googleSignIn.presentingViewController = bridge.viewController
        
        // 通知ロジックを利用。
        // URL によってアプリが開かれた時　AppDelegate から通知される
        NotificationCenter.default.addObserver(self, selector: #selector(notifyFromAppDelegate(notification:)), name: Notification.Name(CAPNotifications.URLOpen.name()), object: nil);
    }

    // echo method
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    
    // グーグルログインメソッドmesoddo
    @objc func signInWithGoogle(_ call: CAPPluginCall) {
        signInCall = call; // このメソッドが呼ばれたことを保存する

        // signin処理が非同期処理なので, dispatch queue に投げる
        DispatchQueue.main.async {
            if self.googleSignIn.hasPreviousSignIn() {
                self.googleSignIn.restorePreviousSignIn();
            } else {
                self.googleSignIn.signIn();
            }
        }
    }
    
    // ログインデータを Dict<string, string> 型 に整理する
    private func googleResponseObject(_ user: GIDGoogleUser ) -> Dictionary<String, String> {
        var data = [:] as! [String : String];
        
        // user Profile
        if let userId = user.userID {
            data.updateValue(userId, forKey: "userId")
        }
        if let name = user.profile.name {
            data.updateValue(name, forKey: "name")
        }
        if let givenName = user.profile.givenName {
            data.updateValue(givenName, forKey: "givenName")
        }
        if let familyName = user.profile.familyName {
            data.updateValue(familyName, forKey: "familyName")
        }
        if let email = user.profile.email {
            data.updateValue(email, forKey: "email")
        }
        if let image = user.profile.imageURL(withDimension: 320) {
            data.updateValue(image.absoluteString, forKey: "image")
        }
        
        // Token
        if let token = user.authentication.idToken {
            data.updateValue(token, forKey: "token")
        }
        if let idToken = user.authentication.idToken {
            data.updateValue(idToken, forKey: "idToken")
        }
        if let refreshToken = user.authentication.refreshToken {
            data.updateValue(refreshToken, forKey: "refreshtoken")
        }
        if let accessToken = user.authentication.accessToken {
            data.updateValue(accessToken, forKey: "accessToken")
        }
        
        return data;
    }
    
    // URLによってアプリが開かれた時の処理
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

// sigin して帰ってくると google の場合これが呼ばれる
extension Sso: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            signInCall?.error(error.localizedDescription);
            return;
        }
        let user = googleResponseObject(user);
        signInCall?.success(user)
    }
}
