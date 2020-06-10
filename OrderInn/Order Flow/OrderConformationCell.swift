//
//  OrderConformationCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 07/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class OrderConformationCell: UITableViewCell {
    static let reuseIdentifier = "OrderConfirmationCell"
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemPrice: UILabel!

    var cartEntry: OrderCart.Entry! {
        didSet {
            itemName.text = "\(cartEntry.item.name) x\(cartEntry.amount.value)"
            itemPrice.text = cartEntry.subtotal.asString()
        }
    }

}
