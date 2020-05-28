//
//  MenuViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 01/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class MenuItem {
    var id, name, imageUrl, category: String
    var order: Int
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        id = doc.documentID
        
        guard let name = data["name"] as? String else { return nil }
        self.name = name
        
        guard let imageUrl = data["image"] as? String else { return nil }
        self.imageUrl = imageUrl
        
        guard let category = data["category"] as? String else { return nil }
        self.category = category
        
        guard let order = data["order"] as? Int else { return nil }
        self.order = order
    }
}

class MenuCategory {
    var id, name, imageUrl: String
    var order: Int
    var items = [MenuItem]()
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        id = doc.documentID

        guard let name = data["name"] as? String else { return nil }
        self.name = name
        
        guard let imageUrl = data["image"] as? String else { return nil }
        self.imageUrl = imageUrl
        
        guard let order = data["order"] as? Int else { return nil }
        self.order = order
    }
}

class MenuViewController: UICollectionViewController {
    
    @IBOutlet var foodSectionCollection: UICollectionView!
    
    var restaurant: Restaurant?
    var tableId, seatId: String?
    
    var categories = [String: MenuCategory]()
    var displayCategories = [MenuCategory]()
    
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodSectionCollection.dataSource = self
        
        loadCategories { (categories) in
            for category in categories {
                self.categories[category.id] = category
            }
            NSLog("OrderInn: MenuVC: Categories loaded (got %d)", self.categories.count)
            self.loadMenuItems { (menuItems) in
                for menuItem in menuItems {
                    guard let category = self.categories[menuItem.category] else { continue }
                    category.items.append(menuItem)
                }

                for item in self.categories {
                    item.value.items.sort(by: { (a, b) in a.order < b.order })
                }
                self.displayCategories = [MenuCategory](self.categories.values)
                self.displayCategories.sort(by: { (a, b) in a.order < b.order })
                self.foodSectionCollection.reloadData()
            }
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
    
    func loadMenuItems(_ completion: @escaping ([MenuItem]) -> Void) {
        fireRef.collection("restaurants").document(restaurant!.id).collection("menu").getDocuments { (snapshot, error) in
            if error != nil {
                NSLog("OrderInn: MenuVC: Failed to load menu items: %s", error.debugDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            var menuItems = [MenuItem]()
            for doc in documents {
                guard let item = MenuItem(doc) else {
                    NSLog("OrderInn: MenuVC: Malformed menu item with id %s", doc.documentID)
                    continue
                }
                menuItems.append(item)
            }
            completion(menuItems)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        NSLog("OrderInn: MenuVC: Returning section count (got %d)", categories.count)
        return displayCategories.count
    }
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        NSLog("OrderInn: MenuVC: Rendering section header for \(indexPath)")
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = displayCategories[section].items.count
        NSLog("OrderInn: MenuVC: Returning section %d item count (got %d)", section, count)
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        NSLog("OrderInn: MenuVC: Rendering collection view cell \(indexPath)")
        let category = displayCategories[indexPath[0]]
//        let item = category.items[indexPath[1]] // still todo
        let cell = foodSectionCollection.dequeueReusableCell(
            withReuseIdentifier: Constance.Cells.catagoryCell, for: indexPath) as! CategoryCell
        cell.diplayCategories(getFoodCategory: category)
        return cell
    }
    
}
