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
    @IBOutlet weak var creditCardImage: UIImageView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var addPaymant: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
       
        popUpView.clipsToBounds = true
        popUpView.layer.cornerRadius = 10
        popUpView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.99, height: self.view.bounds.height * 0.4)
        
        sendOrderButton.layer.cornerRadius = sendOrderButton.frame.height / 2
        orderListTable.dataSource = dataSource
        if let total = cart.total {
            totalOrderAmount.text = total.asString()
            
        }
    }
    
    private func setUpLayout(view: UIView){
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
        ])
    }

    @IBAction func sentOrderButton(_ sender: Any) {
    }
    
    private var popUpLayoutInitialized = false
    @IBAction func selectPaymantTapped(_ sender: Any) {
        if !popUpLayoutInitialized {
            view.addSubview(popUpView)
            setUpLayout(view: popUpView)
            popUpLayoutInitialized = true
        }
        AnimationUtils.animateIn(view: popUpView, style: .FadeAndSlideUp)
    }
    @IBAction func cancelTapped(_ sender: Any) {
        AnimationUtils.animateOut(view: popUpView, style: .FadeAndSlideUp)
    }
    @IBAction func addPaymantTapped(_ sender: Any) {
    }
    
    
    
}
