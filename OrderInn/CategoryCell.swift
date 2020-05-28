//
//  CategoryCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var categoryPhoto: UIImageView!
    
    var category: MenuCategory?
    
    func diplayCategories(getFoodCategory: MenuCategory){
        self.categoryPhoto.image = nil
        self.category = getFoodCategory
        
        categoryName.text = getFoodCategory.name
        
        guard let url = URL(string: getFoodCategory.imageUrl) else { return }
        categoryPhoto.sd_setImage(with: url)
    }
}
