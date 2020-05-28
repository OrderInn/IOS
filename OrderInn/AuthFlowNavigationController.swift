//
//  AuthFlowNavigationController.swift
//  OrderInn
//
//  Created by paulsnar on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import UIKit

class AuthFlowNavigationController: UINavigationController {
    @IBAction func handleLoginDismissal(unwindSegue: UIStoryboardSegue) {
        let orderFlow = UIStoryboard(name: "OrderFlow", bundle: nil)
        view.window?.rootViewController = orderFlow.instantiateInitialViewController()!
    }
}
