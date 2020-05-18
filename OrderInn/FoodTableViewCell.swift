//
//  FoodTableViewCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 09/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import SDWebImage

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealImage: UIImageView!
    
    
    @IBOutlet weak var mealText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPhoto(_ photo:Photo){
        
        mealText.text = photo.type
        
        if let urlString = photo.byurl{
            
            let url = URL(string: urlString)
            
            guard url != nil else {
                print("There isnt url object")
                return
            }
        
        //Nolādēt bildi backgroundā
            mealImage.sd_setImage(with: url) { (image, error, cacgeType, url) in
                
                self.mealImage.image = image
                
            }
        }
    }
}
