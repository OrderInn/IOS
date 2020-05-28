//
//  SignUpViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 26/03/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameTextFieald: UITextField!
    
    @IBOutlet weak var surnameTextFieald: UITextField!
    
    @IBOutlet weak var emailTextFieald: UITextField!
    
    @IBOutlet weak var paswordTextFieald: UITextField!
    
    @IBOutlet weak var signUpPoga: UIButton!
    
    @IBOutlet weak var cancelPoga: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Pārbaudīt vai teksta lauku saturs ir aizpildīts, ja viss ir pareiz, šī metode atgriež nil, ja nē tad erroru.
    func validateFields() -> String? {
        
        //Pārbaudīt vai visi lauki ir aizpildīti
        if nameTextFieald.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            surnameTextFieald.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextFieald.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            paswordTextFieald.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            
            return "Please fill out all the fields."
            
        }
        
        //MARK: -Pārbaudīt vai E-mails ir derīgs
        func isEmailValid(_ Email: String) -> Bool{
            
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTests = NSPredicate(format: "SELF MATCHES %@", emailFormat)
            return emailTests.evaluate(with: Email)
        }
        let correctEmail = emailTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailValid(correctEmail) == false{
            //Epasts nav korekts
            return "Enter correct E-mail"
        }
        //MARK: - Epasta pārbaudes beigas
        
        //MARK: - Pārbaudīt vai parole ir laba
        func isPasswordValid(_ password : String) -> Bool{
        
        let passwordFormat = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES%@",passwordFormat )
        return passwordTest.evaluate(with: password)
        
        }
        let cleanPassword = paswordTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPassword) == false{
            //Password isnt secure enough
            
            return "Please make sure your password os at least 8 charecters, one Capital letter and one number. "
        }
        //MARK: - paroles pārbaudes beigas
        
        return nil
    }
    
    @IBAction func signUpPogaNospiesta(_ sender: Any) {
        
        //Apstiprināt laukus
        let error = validateFields()
        
        if error != nil{
            
            //ja nav nil, tad kaut kas nav kārtībā ar laukiem
            showError(error!)
        }
        else{
            //Radīt tīrās versijas no datiem
            let name = nameTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let surname = surnameTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = paswordTextFieald.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Radīt lietotāju
            Auth.auth().createUser(withEmail:email , password: password) { (result, err) in
                
                //Pārbaudīt errorus
                if err != nil{
                    
                    //Ja iziet caur šo kodu , tad errors parādijās
                    self.showError("Error when creating user")
                }
                else{
                    
                    //Ieaja tika veiksmīgi izveidota, tagad vajag saglabāt vārdu un uzvārdu
                    let database = Firestore.firestore()
                    
                    database.collection("Lietotāji").addDocument(data: ["Name": name, "Surname": surname, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil{
                            
                            //Parādīt error ziņojumu
                            self.showError("Something went wrong, please try again.")
                            
                        }
                        
                    }
                    
                    //Pāriet uz kameras viewController
                    self.moveToCamera()
                    
                }
                
            }
            
        }
        
    }
    
    func showError(_ message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func moveToCamera() {
        performSegue(withIdentifier: "unwindToOrderFlow", sender: nil)
    }
    
    
    @IBAction func cancelPogaNospiesta(_ sender: Any) {
        
//        let startWindow = storyboard?.instantiateViewController(identifier: "LoginStoryboard") as? ViewController
//        view.window?.rootViewController = startWindow
//        view.window?.makeKeyAndVisible()
        
    }
    
        
}
    

    

