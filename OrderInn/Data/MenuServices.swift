//
//  MenuServices.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import Firebase
import OrderInnAPIKit

class MenuItem {
    var id, name, imageUrl, category: String
    var description: String?
    var order: Int
    var image: UIImage?
    var price: Currency
    var apiKit: OrderInnAPIKit.RestaurantMenuItem!
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        id = doc.documentID
        
        guard let name = data["name"] as? String else { return nil }
        self.name = name
        
        guard let imageUrl = data["image"] as? String else { return nil }
        self.imageUrl = imageUrl
        
        guard let category = data["category"] as? String else { return nil }
        self.category = category
        
        guard let order = data["order"] as? Int else { return nil }
        self.order = order
        
        // TODO[pn] remove missing handling because it should not be missing
        price = Currency(from: data["price", default: "EUR 0.00"] as! String)!
    }

    init(from source: OrderInnAPIKit.RestaurantMenuItem) {
        self.id = String(source.id)
        self.name = source.name
        self.imageUrl = source.images.banner.url.absoluteString
        self.description = source.description
        self.order = source.orderPosition
        self.price = Currency(from: source.price)
        self.category = source.categoryId
        self.apiKit = source
    }
}


class MenuCategory {
    var id, name, imageUrl: String
    var order: Int
    var apiKit: OrderInnAPIKit.RestaurantMenuCategory!
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        id = doc.documentID

        guard let name = data["name"] as? String else { return nil }
        self.name = name
        
        guard let imageUrl = data["image"] as? String else { return nil }
        self.imageUrl = imageUrl
        
        guard let order = data["order"] as? Int else { return nil }
        self.order = order
 
    }

    init(from source: OrderInnAPIKit.RestaurantMenuCategory) {
        id = String(source.id)
        name = source.name
        imageUrl = source.images.banner.url.absoluteString
        order = source.orderPosition
        self.apiKit = source
    }
}
