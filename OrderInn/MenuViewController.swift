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

class MenuCategory {
    var id, name, imageUrl: String
    var order: Int
    
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
    
    var categories = [MenuCategory]()
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodSectionCollection.dataSource = self
        
        loadCategories { (categories) in
            self.categories = categories
            self.categories.sort(by: { (a, b) in a.order < b.order })
            self.foodSectionCollection.reloadData()
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // indexPath is a two-level array, indicating which view should be given to it.
        // The first item is the section index; for us it will always equal 0, since we have only one section.
        // The second item is the actual index we're interested in.
        let category = categories[indexPath[1]]
        let cell = foodSectionCollection.dequeueReusableCell(
            withReuseIdentifier: MenuCategoryCell.reuseIdentifier, for: indexPath) as! MenuCategoryCell
        cell.display(category: category)
        return cell
    }
    
}

class MenuCategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "MenuCategoryCell"

    @IBOutlet var categoryName: UILabel!
    @IBOutlet var categoryPhoto: UIImageView!
    
    var category: MenuCategory?

    func display(category: MenuCategory) {
        self.category = category
        categoryName.text = category.name
        
        guard let url = URL(string: category.imageUrl) else { return }
        categoryPhoto.sd_setImage(with: url)
    }
}
