//
//  ConstanceFiles.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 29/03/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import FirebaseDatabase

let dbRef = Database.database().reference()

struct Constance {
    
    struct Storyboards {
        
       static let cameraViewController = "CameraView"
        
    }
    
    struct Cells {
        static let mealTypeCell = "MealPhoto"
        
    }
    
    struct Paths{
        
        static let cafeDelMar = dbRef.child("CafeDelMarMenu")
        
    }
    
}
