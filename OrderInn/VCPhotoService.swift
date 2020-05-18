//
//  VCPhotoService.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 05/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class PhotoService{
    
    static func getPhoto(completion: @escaping ([Photo]) -> Void) -> Void {
        
        //Dabūt atsauci uz datuāzi
        let dbref = Database.database().reference()
        
        //Datubāzes izsaukšana
        //TODO: Vajag izveidot db izaukšanu ar qr coda stringu
        dbref.child("").observeSingleEvent(of: .value) { (snapshot) in
            
            var retrivedPhotos = [Photo]()
            
            //Dabut snapšotu sarakstu
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            
            if let snapshots = snapshots {
                
                //Izlūpot cauti snapshotiem un parsēt tos
                for snap in snapshots{
                    
                    //Radīt bildi no snapshota
                    let p = Photo(snapshot: snap)
                    
                    if p != nil{
                        
                        retrivedPhotos.insert(p!, at: 0)
                        
                    }
                    
                }
                
            }
            
            //Pec bilžu parsēšanas jaizsauc completion
            completion(retrivedPhotos)
            
        }
        
    }
    
}
