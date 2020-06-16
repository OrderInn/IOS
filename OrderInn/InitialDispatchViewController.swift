//
//  InitialDispatchViewController.swift
//  OrderInn
//
//  Created by paulsnar on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Firebase
import Foundation
import UIKit

class InitialDispatchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        var storyboard: UIStoryboard
        if Firebase.Auth.auth().currentUser == nil {
            storyboard = UIStoryboard(name: "AuthView", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "OrderFlow", bundle: nil)
        }
        
        let destination = storyboard.instantiateInitialViewController()!

        let segue = UIStoryboardSegue(identifier: nil, source: self, destination: destination, performHandler: {
            // TODO this is still one huge hack
            UIApplication.shared.windows.first?.rootViewController = destination
        })
        segue.perform()
    }
}

