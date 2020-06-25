//
//  OrderConformation.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 07/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation

class OrderConformation: UIViewController {
    
    @IBOutlet weak var orderListTable: UITableView!
    @IBOutlet weak var totalOrderAmount: UILabel!
    @IBOutlet weak var sendOrderButton: UIButton!
    
    let cart = OrderCart.shared
    
    class OrderTableViewDataSource: NSObject, UITableViewDataSource {
        let cart = OrderCart.shared

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard section == 0 else { fatalError("OrderConfirmation: Unknown section: \(section)") }
            return cart.entries.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let index = indexPath[1]
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConformationCell.reuseIdentifier, for: indexPath) as! OrderConformationCell
            cell.cartEntry = cart.entries[index]
            return cell
        }
    }
    
    
    
    let dataSource = OrderTableViewDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendOrderButton.layer.cornerRadius = sendOrderButton.frame.height / 2
        orderListTable.dataSource = dataSource
        if let total = cart.total {
            totalOrderAmount.text = total.asString()
        }
    }

    @IBAction func sentOrderButton(_ sender: Any) {
    }
    
}
