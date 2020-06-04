//
//  MenuTableCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import SDWebImage

protocol MenuTableCellProtocol {
    func getShownItem() -> MenuItem?
    func display(menuItem: MenuItem)
}

class MenuCollapsedTableCell: UITableViewCell, MenuTableCellProtocol {
    static let reuseIdentifier = "MenuCollapsedTableCell"

    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemImage: UIImageView!

    var item: MenuItem!
    
    func getShownItem() -> MenuItem? {
        item
    }

    func display(menuItem item: MenuItem) {
        self.item = item

        itemTitle.text = item.name
        itemDescription.text = item.description
        itemPrice.text = item.price
        
        guard let url = URL(string: item.imageUrl) else { return }
        itemImage.layer.cornerRadius = 5.0
        itemImage.sd_setImage(with: url) { _, _, _, _ in
            item.image = self.itemImage.image
        }
    }
}

class MenuExpandedTableCell: UITableViewCell, MenuTableCellProtocol {
    static let reuseIdentifier = "MenuExpandedTableCell"
    
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
    var item: MenuItem?
    
    func getShownItem() -> MenuItem? {
        item
    }
    
    func display(menuItem item: MenuItem) {
        self.item = item

        itemTitle.text = item.name
        itemDescription.text = item.description
        itemPrice.text = item.price
        
        if let image = item.image {
            itemImage.image = image
        } else {
            guard let url = URL(string: item.imageUrl) else { return }
            itemImage.sd_setImage(with: url) { _, _, _, _ in
                item.image = self.itemImage.image
            }
        }
    }
}



