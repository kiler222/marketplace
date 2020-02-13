//
//  MenuViewController.swift
//  yogismarket
//
//  Created by kiler on 13/02/2020.
//  Copyright © 2020 kiler. All rights reserved.
//

import UIKit
import FirebaseUI

class MenuViewController: UIViewController, FUIAuthDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://example.appspot.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")

        let emailProvider = FUIEmailAuth(authAuthUI: FUIAuth.defaultAuthUI()!,
                                         signInMethod: EmailLinkAuthSignInMethod,
                                    forceSameDevice: false,
                                    allowNewEmailAccounts: true,
                                    actionCodeSetting: actionCodeSettings)
        
        
        
        if Auth.auth().currentUser != nil {
          //do something :D
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
//            provider = FUIOAuth.appleAuthProvider()
            let providers: [FUIAuthProvider] = [ FUIOAuth.appleAuthProvider(), FUIFacebookAuth(),
                FUIGoogleAuth(), emailProvider]

            authUI?.providers = providers
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
