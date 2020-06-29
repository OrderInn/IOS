//
//  AuthViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 20/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import OrderInnAPIKit
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
        // TODO: implement proper email auth
        Client.shared.legacyLoginWithEmailAndPassword(email: "abcdef@test.orderinn.app", password: "abcdef") {
            user, error in
            DispatchQueue.main.async {
                if user != nil {
                    UserDefaults.standard.set(true, forKey: "group.orderinn.ios.order.is-user-logged-in")
                    self.view.window?.rootViewController = UIStoryboard(name: "OrderFlow", bundle: nil).instantiateInitialViewController()!
                } else {
                    log("Error while logging in: %@", String(describing: error))
                    let message: String
                    if error is APIError {
                        message = (error as! APIError).message
                    } else {
                        message = "Sorry, something went wrong. Please try again later."
                    }
                    self.showConfirmAlert(title: "Could Not Log In", message: message, completion: noop)
                }
            }
        }
    }
}
