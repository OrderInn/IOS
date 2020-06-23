//
//  SlideMenuViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 23/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

enum MenuType: Int{
    case home
    case menu
    case settings
    case retakeQrShot
    case signOut
}

class SlideMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true) {
            print("Dissmissing\(menuType)")
        }
    }

}
