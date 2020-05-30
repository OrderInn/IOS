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
    var id, name, imageUrl, category: String
    var order: Int
    
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
