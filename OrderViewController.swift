//
//  OrderViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 01/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import BonsaiController

class OrderViewController: UIViewController {
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var itemDescr: UILabel!
    @IBOutlet weak var itemPrice: UILabel!

    var menuItem: MenuTableCell?
    var Img:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        menuImage.image = menuItem?.itemPhoto.image
        menuName.text = menuItem?.foodName.text
        
    }
    
    @IBAction func addToOrder(_ sender: Any) {
    }

}
