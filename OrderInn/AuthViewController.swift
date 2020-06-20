//
//  AuthViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 20/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

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
    }
    


}
