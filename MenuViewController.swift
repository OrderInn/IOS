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

class MenuViewController: UITableViewController {

    @IBOutlet var menuTable: UITableView!
    
    var restaurant: Restaurant?
    var category: MenuCategory?
    var items = [MenuItem]()
    var opened = Bool()

    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        tableView.dataSource = self
        
        loadItems {
            self.tableView.reloadData()
        }
   }
    
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
        let cell = menuTable.dequeueReusableCell(withIdentifier: MenuTableCell.reuseIdentifier, for: indexPath) as! MenuTableCell
        cell.display(item: item)
        return cell
    }

}

