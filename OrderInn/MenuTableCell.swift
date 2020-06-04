//
//  MenuTableCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import SDWebImage

class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var itemPhoto: UIImageView!
    
    
    static let reuseIdentifier = "MenuItemCell"
    var item: MenuItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func display(item: MenuItem) {
        self.item = item

        foodName.text = item.name
        
        guard let url = URL(string: item.imageUrl) else { return }
        itemPhoto.sd_setImage(with: url)
        
        background.layer.shadowColor = UIColor.gray.cgColor
        background.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        background.layer.shadowOpacity = 3.0
        background.layer.masksToBounds = false
        background.layer.cornerRadius = 15.0
        itemPhoto.layer.cornerRadius = 15.0
    }
    

    
}




