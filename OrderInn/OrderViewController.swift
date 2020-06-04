//
//  OrderViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 03/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    var oneItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func hidePopOver(_ sender: Any) {
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
