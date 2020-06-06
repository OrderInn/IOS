//
//  OrderCart.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 06/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation

class Cart {
    
    private(set) var items : [CartItem] = []
    
    var total : Float{
        get{
            return items.reduce(0.0) { value, item in
                value + item.subTotal
            }
        }
    }
    var totalQuantity : Int {
        get{
            return items.reduce(0) { value, item in
                value + item.quantity
            }
        }
    }
    func UpdateCart(with item: MenuItem){
        if !self.contains(menuItem: item){
            self.add(menuItem: item)
        }else{
            self.remove(menuItem: item)
        }
    }
    func updateCart(){
        for item in self.items{
            if item.quantity == 0 {
                UpdateCart(with: item.items)
            }
        }
    }
    
    func add(menuItem: MenuItem){
        let item = items.filter{ $0.items == menuItem}
        if item.first != nil{
            item.first?.quantity += 1
        }else{
            items.append(CartItem(item: menuItem))
        }
    }
    func remove(menuItem:MenuItem){
        guard let index = items.firstIndex(where: {$0.items == menuItem}) else {return}
        items.remove(at: index)
    }
    
    func contains(menuItem : MenuItem) -> Bool{
        let item = items.filter{$0.items == menuItem}
        return item.first != nil
    }
    
}
    



