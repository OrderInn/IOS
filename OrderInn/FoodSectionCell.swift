//
//  FoodSectionCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class FoodSectionCell: UICollectionViewCell {
    
    @IBOutlet weak var foodSectionPhoto: UIImageView!
    
    @IBOutlet weak var foodSectionName: UILabel!
    
    var photo: MenuViewController.PhotoParameters?
    
    
    
    func displayPhoto(photo: MenuViewController.PhotoParameters ){
        
        foodSectionName.text = photo.byName
        
    }
}
