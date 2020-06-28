//
//  AuthViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 20/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Firebase
import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var logInWithApple: UIButton!
    @IBOutlet weak var logInWithFacebook: UIButton!
    @IBOutlet weak var logInWithEmail: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        logInWithApple.layer.cornerRadius = 15
        logInWithEmail.layer.cornerRadius = 15
        logInWithFacebook.layer.cornerRadius = 15
        
    }
    
    @IBAction func logInWithAppleTapped(_ sender: Any) {
    }
    @IBAction func logInWithFacebookTapped(_ sender: Any) {
    }
    @IBAction func logInWithEmailTapped(_ sender: Any) {
        let auth = Firebase.Auth.auth()
        auth.signIn(withEmail: "abcdef@orderinn.app", password: "abcdef") { data, error in
            guard let data = data else {
                let error = String(describing: error)
                NSLog("OrderInn: Auth: Something went wrong? \(error)")
                return
            }
            auth.updateCurrentUser(data.user, completion: { error in
                self.view.window?.rootViewController = UIStoryboard(name: "OrderFlow", bundle: nil).instantiateInitialViewController()!
            })
        }
    }
    


}
