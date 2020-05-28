//
//  CategoryCell.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 28/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryPhoto: UIImageView!
    
    var category: MenuCategory?
    
    func diplayCategories(getFoodCategory: MenuCategory){
        self.categoryPhoto.image = nil
        self.category = getFoodCategory
        
        categoryName.text = getFoodCategory.name
        if getFoodCategory.imageUrl == nil{
            return
        }
        
        if let cacheImage = ImageCache.getImage(url: getFoodCategory.imageUrl!){
            self.categoryPhoto.image = cacheImage
            return
        }
        
        let url = URL(string: getFoodCategory.imageUrl!)
        if url == nil{
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, responder, error) in
            if error == nil && data != nil{
                let image = UIImage(data: data!)
                
                ImageCache.saveImage(url: url!.absoluteString, image: image)
                if url!.absoluteString != self.category?.imageUrl!{
                    return
                }
                DispatchQueue.main.async {
                    self.categoryPhoto.image = image
                }
            }
        }
        dataTask.resume()
    }
    
    class ImageCache:CategoryCell{
        
        static var cache = [String:UIImage]()
        
        static func saveImage(url: String?, image:UIImage?){
            if url == nil || image == nil {
                return
            }
            cache[url!] = image!
        }
        static func getImage(url: String?) -> UIImage?{
            if url == nil{
                return nil
            }
            return cache[url!]
        }
        
    }
    
}
