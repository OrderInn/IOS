//
//  OrderConformationCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 07/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

protocol CartItemDelegate {
    func updateCartItem(cell: OrderConformationCell, quantity: Int)
}

class OrderConformationCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    var delegate: CartItemDelegate?
    var quantity: Int = 1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
