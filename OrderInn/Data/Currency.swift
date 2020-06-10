//
//  Currency.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 08/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import UIKit

struct Currency {
    typealias Symbol = String
    
    let symbol: Symbol
    var value: Int
    
    init?(from string: String) {
        let parts = string.split(separator: " ")
        guard parts.count == 2 else { return nil }
        symbol = Symbol(parts[0])
        
        let amountParts = parts[1].split(separator: ".")
        guard amountParts.count == 2 else { return nil }
        
        // TODO[pn] this works only for cent-based currencies; needs adjustment for others!
        guard let units = Int(String(amountParts[0])) else { return nil }
        guard let cents = Int(String(amountParts[1])) else { return nil }
        value = units * 100 + cents
    }
    
    init(symbol: Symbol, value: Int) {
        self.symbol = symbol
        self.value = value
    }
    
    init(symbol: Symbol) {
        self.init(symbol: symbol, value: 0)
    }
    
    static func *(lhs: Currency, rhs: Int) -> Currency {
        return Currency(symbol: lhs.symbol, value: lhs.value * rhs)
    }
 
    func asString() -> String {
        let symbol = self.symbol as String
        let units = value / 100
        let cents = value % 100
        return String(format: "%@ %d.%02d", symbol, units, cents)
    }
}
extension Currency.Symbol {
    static let Eur = Currency.Symbol("EUR")
}
