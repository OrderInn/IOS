//
//  MenuViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MenuItemViewController: UITableViewController {
    
    @IBOutlet weak var checkoutview: UIView!
    
    var restaurant: Restaurant?
    var category: MenuCategory?
    var properties: MenuItem?
    var items = [MenuItem]()
    var isRowExpanded = [Int: Bool]()
    
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        loadItems {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Data stuff
    
    func loadItems(_ completion: @escaping () -> Void) {
        fireRef.collection("restaurants")
        .document(restaurant!.id)
        .collection("menu")
        .whereField("category", isEqualTo: category!.id)
        .getDocuments { (snapshot, error) in
            if error != nil {
                NSLog("OrderInn: MenuItemVC: Failed to fetch menu items: %s", error.debugDescription)
                // TODO: show alert
                self.navigationController?.popViewController(animated: true)
                return
            }
        
            guard let documents = snapshot?.documents else {
                NSLog("OrderInn: MenuItemVC: Category %s is empty", self.category!.id)
                // TODO: show notice or alert
                self.navigationController?.popViewController(animated: true)
                return
            }

            for doc in documents {
                guard let menuItem = MenuItem(doc) else {
                    NSLog("OrderInn: MenuItemVC: Malformed menu item with id %s", doc.documentID)
                    continue
                }
                self.items.append(menuItem)
            }
            
            completion()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath[1]
        let item = items[index]
        let reuseIdentifier: String
        if isRowExpanded[index, default: false] {
            reuseIdentifier = MenuExpandedTableCell.reuseIdentifier
        } else {
            reuseIdentifier = MenuCollapsedTableCell.reuseIdentifier
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if var menuCell = cell as? MenuTableCellProtocol {
            menuCell.item = item
        }
        return cell
    }

    // MARK: UI stuff
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        AnimationUtils.fadeIn(cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath[1]
        self.isRowExpanded[row] = !self.isRowExpanded[row, default: false]
        
        // TODO[pn] this is bad but it actually works :woozy_face:
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
}




