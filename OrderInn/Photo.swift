//
//  CollectionViewPhoto.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 03/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Photo {

    //Datubāzes dati kuri tur eksisē, un nosaka par tukšiem dictionary vērtībām.
    var byResturount:String?
    var type:String?
    var menuType:String?
    var bymeal:String?
    var byurl:String?
    
    
    
    init?(snapshot:DataSnapshot){
        
        //Foto dati
        let photoData = snapshot.value as? [String:String]
        
        if let photoData = photoData{
            
            let resturount = snapshot.key
            
            let url = photoData["url"]
            let meal = photoData["Meal"]
            
            guard url != nil && meal != nil else {
                
                return nil
                
            }
            
            self.byResturount = resturount
            self.bymeal = meal
            self.byurl = url
            
        }
        
    }
}
