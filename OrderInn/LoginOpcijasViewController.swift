//
//  LoginOpcijasViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 26/03/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginOpcijasViewController: UIViewController {
    
    
    @IBOutlet weak var emailAdress: UITextField!
    
    @IBOutlet weak var paswordTextFieald: UITextField!
    
    @IBOutlet weak var loginPoga: UIButton!
    
    @IBOutlet weak var signUpPoga: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPogaNospiesta(_ sender: Any) {
        
        //TODO: Apstiprināt teksta laukus
        func validateLoginFiealds() -> String?{
        
            if emailAdress.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                paswordTextFieald.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                return "Please fill out all fields"
                
            }
            return nil
        }

        //Radīt tīro versiju no teksta laukiem
        let email = emailAdress.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = paswordTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Ielogot lietotāju
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                
                //Ja nav nil, tad nevar ielogoties
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                
            }
            else{
                
                self.performSegue(withIdentifier: "unwindToOrderFlow", sender: nil)
                
            }
            
        }
        
    }
    
    
    @IBAction func signUpPogaNospiesta(_ sender: Any) {
    }
    

}
