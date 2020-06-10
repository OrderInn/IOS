//
//  MenuTableCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Combine
import UIKit
import SDWebImage

protocol MenuTableCellProtocol {
    var item: MenuItem! { get set }
}

class MenuCollapsedTableCell: UITableViewCell, MenuTableCellProtocol {
    static let reuseIdentifier = "MenuCollapsedTableCell"

    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemImage: UIImageView!

    var item: MenuItem! {
        didSet {
            itemTitle.text = item.name
            itemDescription.text = item.description
            itemPrice.text = item.price.asString()
            
            guard let url = URL(string: item.imageUrl) else { return }
            itemImage.layer.cornerRadius = 5.0
            itemImage.sd_setImage(with: url) { _, _, _, _ in
                self.item.image = self.itemImage.image
            }
        }
    }
}

class MenuExpandedTableCell: UITableViewCell, MenuTableCellProtocol {
    static let reuseIdentifier = "MenuExpandedTableCell"
    
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemImage: UIImageView!

    var cartItem: OrderCart.Entry!
    var item: MenuItem! {
        didSet {
            cartItem = OrderCart.shared.entry(for: item!)
            
            itemTitle.text = item.name
            itemDescription.text = item.description
            itemPrice.text = item.price.asString()
            
            if let image = item.image {
                itemImage.image = image
            } else {
                guard let url = URL(string: item.imageUrl) else { return }
                itemImage.sd_setImage(with: url) { _, _, _, _ in
                    self.item.image = self.itemImage.image
                }
            }
            
            quantitySubscription = cartItem.amount.sink(
                receiveCompletion: { _ in },
                receiveValue: { self.itemCount.text = String($0) })
        }
    }
    var quantitySubscription: AnyCancellable?
    
    func dispose() {
        quantitySubscription?.cancel()
    }

    @IBAction func itemCountUpdate(_ sender: Any) {
        if (sender as! UIButton).tag == 0 {
            cartItem.amount.value += 1
        } else {
            cartItem.amount.value -= 1
        }
    }
}



