//
//  MenuServices.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import OrderInnAPIKit
import UIKit

class MenuItem {
    var id, name, imageUrl, category: String
    var description: String?
    var order: Int
    var image: UIImage?
    var price: Currency
    var apiKit: OrderInnAPIKit.RestaurantMenuItem!

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

    init(from source: OrderInnAPIKit.RestaurantMenuCategory) {
        id = String(source.id)
        name = source.name
        imageUrl = source.images.banner.url.absoluteString
        order = source.orderPosition
        self.apiKit = source
    }
}
