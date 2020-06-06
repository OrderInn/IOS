//
//  MenuServices.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import Firebase

class MenuItem {
    // TODO: move Price to a Currency type
    var id, name, imageUrl, category, price: String
    var description: String?
    var order: Int
    var image: UIImage?
    
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
        
        // TODO remove the else clause when it's ready
        if let price = data["price"] as? String {
            self.price = price
        } else {
            self.price = "- 0.00"
        }
    }
    open var toPrice : Float{
        if let price = Float(price){
            return price
        }
        return self.toPrice
    }
}

extension MenuItem{
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool{
        return lhs.price == rhs.price && lhs.name == lhs.name
    }
}


class MenuCategory {
    var id, name, imageUrl: String
    var order: Int
    
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
}
