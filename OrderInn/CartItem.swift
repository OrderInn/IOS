//
//  CartItem.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 06/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation

class CartItem{
    var quantity : Int = 1
    var items : MenuItem!
    
    open var subTotal : Float{get{return items!.toPrice * Float(quantity)}}
    
    init(item: MenuItem){
        self.items = item
    }
}
