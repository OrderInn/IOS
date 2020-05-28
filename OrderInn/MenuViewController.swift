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

struct MenuCategory {
    var id, name, imageUrl: String?
    var order: Int?
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        // TODO validate schema
    
        id = doc.documentID
        let byName = data["name"] as? String
        let byImageUrl = data["image"] as? String
        let byOrder = data["order"] as? Int
        
        
        if name == nil || imageUrl == nil || order == nil{
            self.imageUrl = byImageUrl
            self.order = byOrder
            self.name = byName
        }
    }
}

class MenuViewController: UICollectionViewController {
    
    @IBOutlet var foodSectionCollection: UICollectionView!
    
    var restaurant: Restaurant?
    var tableId, seatId: String?
    // TODO: fetch menu, do something useful...
    
    var categories = [MenuCategory]()
    
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodSectionCollection.delegate = self
        foodSectionCollection.dataSource = self
        
        loadCategories { (retrivedCategory) in
            self.categories = retrivedCategory
            self.foodSectionCollection.reloadData()
        }
    }
    
    func loadCategories(_ completion: @escaping ([MenuCategory]) -> Void) {
        fireRef.collection("restaurants").document(restaurant!.id).collection("menu_categories").getDocuments { (snapshot, error) in
            if error != nil{
                return
            }
            let documents = snapshot?.documents
            if let documents = documents{
                var categoriesArray = [MenuCategory]()
                for doc in documents{
                    let p = MenuCategory(doc)
                    categoriesArray.insert(p!, at: 0)
                }
                completion(categoriesArray)
            }
            
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foodSectionCollection.dequeueReusableCell(withReuseIdentifier: Constance.Cells.catagoryCell, for: indexPath) as? CategoryCell
        let foodCategory = self.categories[indexPath.row]
        cell?.diplayCategories(getFoodCategory: foodCategory)
        return cell!
    }
    
}
