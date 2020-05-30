//
//  CategoryViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class CategoryViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var tableId, seatId: String?
    
    var categories = [MenuCategory]()
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        loadCategories { (categories) in
            self.categories = categories
            self.categories.sort(by: { (a, b) in a.order < b.order })
            self.tableView.reloadData()
        }
    }

    func loadCategories(_ completion: @escaping ([MenuCategory]) -> Void) {
        fireRef.collection("restaurants").document(restaurant!.id).collection("menu_categories").getDocuments { (snapshot, error) in
            if error != nil {
                NSLog("OrderInn: MenuVC: Failed to load categories: %s", error.debugDescription)
                return
            }
            let documents = snapshot?.documents
            if let documents = documents{
                var categoriesArray = [MenuCategory]()
                for doc in documents {
                    guard let category = MenuCategory(doc) else {
                        NSLog("OrderInn: MenuVC: Malformed category with id %s", doc.documentID)
                        continue
                    }
                    categoriesArray.append(category)
                }
                completion(categoriesArray)
            }
            
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath[1]]
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCategoryCell.reuseIdentifier, for: indexPath) as! MenuCategoryCell
        cell.display(category: category)
        return cell
    }
    
    // MARK: Segue Data Passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? MenuCategoryCell else { return }
        let category = cell.category!
        if let menuItemVC = segue.destination as? MenuViewController {
            menuItemVC.restaurant = restaurant!
            menuItemVC.category = category
        }
    }


}


