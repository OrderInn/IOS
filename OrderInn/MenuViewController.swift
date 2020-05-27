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
    
    var qrResult: QRURI?
    var restaurant: Restaurant?
    
    public func receivePreviousData(qrResult: QRURI, restaurant: Restaurant) {
        self.qrResult = qrResult
        self.restaurant = restaurant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData() {
        let fireRef = Firestore.firestore()
    }
}


