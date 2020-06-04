//
//  OrderViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 03/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var menuItemPhoto: UIImageView!
    @IBOutlet weak var menuItemName: UILabel!
    @IBOutlet weak var menuItemPrice: UILabel!
    
    
    var oneItem: MenuItem?
    var photo: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        menuItemName.text = oneItem?.name
        menuItemPhoto.image = photo?.image
    }
    
    @IBAction func dismissPopOver(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

@IBDesignable class ViewDesign:UIView{
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
