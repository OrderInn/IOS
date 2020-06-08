//
//  Currency.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 08/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation

struct Currency: Codable {
    
    var quotes : Dictionary<String,Float>
    var timestamp : Int64
}

class CurrencyHelper{
    
    var currency : Currency?
    var selectedCurrency: String = "EUR"
    
    
func display(total: Float) -> String {
    let newTotal = totalInCurrency(name: selectedCurrency, for: total)
    return String(format: "%.2f", newTotal) + " " + selectedCurrency
}
func totalInCurrency(name: String, for total: Float) -> Float {
    self.selectedCurrency = name
    guard let rate = currency?.quotes["USD"+name] else { return total }
    return total * rate
}
}
