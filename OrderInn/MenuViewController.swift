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

struct MenuItem {
    var id, name, category, imageUrl: String
    var order: Int
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        // TODO validate schema
        
        id = doc.documentID
        name = data["name"] as! String
        category = data["category"] as! String
        imageUrl = data["image"] as! String
        order = data["order"] as! Int
    }
}

struct MenuCategory {
    var id, name, imageUrl: String
    var order: Int
    var items: [MenuItem]
    
    init?(_ doc: QueryDocumentSnapshot) {
        let data = doc.data()
        // TODO validate schema
    
        id = doc.documentID
        name = data["name"] as! String
        imageUrl = data["image"] as! String
        order = data["order"] as! Int
        items = [MenuItem]()
    }
}

class MenuViewController: UICollectionViewController {
    
    @IBOutlet var foodSectionCollection: UICollectionView!
    
    var photos = [PhotoParameters]()
    var restaurant: Restaurant?
    var tableId, seatId: String?
    // TODO: fetch menu, do something useful...
    
    var categories = [String: MenuCategory]()
    
    let fireRef = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodSectionCollection.delegate = self
        foodSectionCollection.dataSource = self
        
        loadCategories() {
            self.loadMenuItems() {
                self.showData()
            }
        }
    }
    
    func loadCategories(_ completion: @escaping () -> Void) {
        fireRef.collection("restaurants").document(restaurant!.id).collection("menu_categories").getDocuments { (snapshot, error) in
            guard let docs = snapshot?.documents, error == nil else { return }
            for doc in docs {
                guard let category = MenuCategory(doc) else { continue }
                self.categories[category.id] = category
            }
            completion()
        }
    }
    
    func loadMenuItems(_ completion: @escaping () -> Void) {
        fireRef.collection("restaurants").document(restaurant!.id).collection("menu").getDocuments { (snapshot, error) in
            guard let docs = snapshot?.documents, error == nil else { return }
            for doc in docs {
                guard let item = MenuItem(doc) else { continue }
                self.categories[item.category]!.items.append(item)
            }
            completion()
        }
    }
    
    func showData() {
        // todo...
    }
    
    class PhotoService{
        
        static func retrivePhotos(restaurant id: String, completion: @escaping ([PhotoParameters]) -> Void){
            let fireRef = Firestore.firestore()
            fireRef.collection("restaurants").document(id).collection("menu_categories").getDocuments { (snapshot, error) in
                if error != nil{
                    return
                }
                let documents = snapshot?.documents
                if let documents = documents{
                    var photoArray = [PhotoParameters]()
                    for doc in documents{
                        let p = PhotoParameters(snapshot: doc)
                        if p != nil {
                            photoArray.insert(p!, at: 0)
                        }
                    }
                    completion(photoArray)
                }
            }
        }
        
    }
    
    struct PhotoParameters{
        var byImage:String?
        var byName:String?
        var byOrder:Int?
        
        init? (snapshot:QueryDocumentSnapshot){
            let data = snapshot.data()
            let image = data["image"] as? String
            let name = data["name"] as? String
            let order = data ["order"] as? Int
            
            if image == nil || name == nil || order == nil {
                return nil
            }
            self.byImage = image
            self.byName = name
            self.byOrder = order
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foodSectionCollection.dequeueReusableCell(withReuseIdentifier: Constance.Cells.foodSection, for: indexPath) as? FoodSectionCell
        let photo = self.photos[indexPath.row]
        cell?.displayPhoto(photo: photo)
        return cell!
    }
    
}
