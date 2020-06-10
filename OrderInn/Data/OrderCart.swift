//
//  OrderCart.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 06/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Combine
import Foundation

class OrderCart {
    static let shared = OrderCart()
    
    class Entry {
        let item: MenuItem
        let amount = CurrentValueSubject<Int, Never>(0)

        init(item: MenuItem) {
            self.item = item
        }
        
        var subtotal: Currency {
            get { item.price * amount.value }
        }
    }
    
    private var _internalEntries = [String: Entry]()
    private var _subs = [AnyCancellable]()
    
    func entry(for item: MenuItem) -> Entry {
        if let entry = _internalEntries[item.id] {
            return entry
        }

        let entry = Entry(item: item)
        _internalEntries[item.id] = entry
        
        let sub = entry.amount.sink { _ in
            self.updateState()
        }
        _subs.append(sub)

        return entry
    }
    
    private func updateState() {
        var quantity = 0
        var total = Currency(symbol: state.total.symbol)
        
        for entry in entries {
            quantity += entry.amount.value
            guard total.symbol == entry.subtotal.symbol else { fatalError("Currency symbol mismatch") }
            total.value += entry.subtotal.value
        }

        state = CartState(quantity: quantity, total: total)
    }
    
    var entries: [Entry] {
        get {
            _internalEntries.values.filter({ $0.amount.value > 0 })
        }
    }

    var total: Currency? {
        get {
            var symbol: Currency.Symbol
            var value = 0
            guard let firstEntry = _internalEntries.first?.value else { return nil }
            symbol = firstEntry.item.price.symbol
            for (_, entry) in _internalEntries {
                let subtotal = entry.subtotal
                // TODO[pn] this should be logged because it should never occur
                guard subtotal.symbol == symbol else { return nil }
                value += subtotal.value
            }
            return Currency(symbol: symbol, value: value)
        }
    }
    
    // MARK: Combine
    
    struct CartState {
        let quantity: Int
        let total: Currency
    }
    
    @Published var state = CartState(quantity: 0, total: Currency(symbol: Currency.Symbol.Eur))
}

