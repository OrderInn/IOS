//
//  OrderConformation.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 07/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class OrderConformation: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderListTable: UITableView!
    @IBOutlet weak var totalOrderAmount: UILabel!
    
    var currency = CurrencyHelper()
    var cart : Cart?
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    var quotes : [(key: String, value: Float)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListTable.dataSource = self
        orderListTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.totalOrderAmount.text = (self.cart?.total.description)! + "" + self.currency.selectedCurrency
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cart?.items.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! MenuExpandedTableCell
        if let cartItem = cart?.items[indexPath.item]{
            cell.delagate = self as? CartDelegate
            cell.itemTitle.text = cartItem.items.name
            cell.itemPrice.text = cartItem.items.displayPrice()
            cell.quantity = cartItem.quantity
        }
        return cell
    }

    
    @IBAction func sentOrderButton(_ sender: Any) {
    }
    
}
extension OrderConformation:CartItemDelegate{
    func updateCartItem(cell: OrderConformationCell, quantity: Int) {
        guard let indexPath = orderListTable.indexPath(for: cell) else {return}
        guard let cartItem = cart?.items[indexPath.row] else {return}
        
        cartItem.quantity = quantity
        
        guard let total = cart?.total else{return}
        totalOrderAmount.text = currency.display(total: total)
    }
    
    
}
