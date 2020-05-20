//
//  MenuViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 01/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var mealTypeTable: UITableView!
    
    var qrString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let fireRef = Firestore.firestore()
        
        fireRef.collection("restaurants").document("\(String(describing: qrString))").getDocument { (docSnap, error) in
            if error == nil && docSnap != nil && docSnap!.data() != nil {
                print(docSnap!.data()!)
                print(self.qrString!)
            }
        }
    }
}


