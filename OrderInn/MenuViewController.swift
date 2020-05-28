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

class MenuViewController: UICollectionViewController {
    
    @IBOutlet var foodSectionCollection: UICollectionView!
    
    var photos = [PhotoParameters]()
    var restaurant: Restaurant?
    var tableId, seatId: String?
    // TODO: fetch menu, do something useful...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoService.retrivePhotos { (retrivedPhotos) in
            self.photos = retrivedPhotos
            self.foodSectionCollection.reloadData()
        }
        
        foodSectionCollection.delegate = self
        foodSectionCollection.dataSource = self
        
    }
    
    class PhotoService{
        
        static func retrivePhotos(completion: @escaping([PhotoParameters]) -> Void){
            let fireRef = Firestore.firestore()
            fireRef.collection("menu_categories").getDocuments { (snapshot, error) in
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
