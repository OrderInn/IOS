//
//  InitialDispatchViewController.swift
//  OrderInn
//
//  Created by paulsnar on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import UIKit

class InitialDispatchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard: UIStoryboard
        if UserDefaults.standard.bool(forKey: "group.orderinn.ios.order.is-user-logged-in") {
            storyboard = UIStoryboard(name: "OrderFlow", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "Onbording", bundle: nil)
        }

        let destination = storyboard.instantiateInitialViewController()!
        let segue = UIStoryboardSegue(identifier: nil, source: self, destination: destination) {
            // TODO: this is still one huge hack
            UIApplication.shared.windows.first?.rootViewController = destination
        }
        segue.perform()
    }
}

