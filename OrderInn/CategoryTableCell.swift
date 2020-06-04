//
//  CategoryTableCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import SDWebImage

class MenuCategoryCell: UITableViewCell {
    
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var categoryPhoto: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    static let reuseIdentifier = "MenuCategoryCell"
    var category: MenuCategory?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func display(category: MenuCategory) {
        
        self.category = category

        categoryName.text = category.name
        
        guard let url = URL(string: category.imageUrl) else { return }
        categoryPhoto.sd_setImage(with: url)
        
        background.layer.shadowColor = UIColor.white.cgColor
        background.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        background.layer.shadowOpacity = 3.0
        background.layer.masksToBounds = false
        background.layer.cornerRadius = 15.0
        categoryPhoto.layer.cornerRadius = 15.0
        
    }

}
