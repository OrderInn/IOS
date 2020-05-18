//
//  MenuViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 01/04/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage
import FirebaseDatabase

class MenuViewController: UIViewController {
    

    @IBOutlet weak var mealTypeTable: UITableView!
    
    var photos = [Photo]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Atgūt un parādīt bildes
        PhotoService.getPhoto { (photo) in
            
            self.photos = photo
            self.mealTypeTable.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Konfigurēt tableView
        mealTypeTable.dataSource = self
        mealTypeTable.delegate = self
    
    }

}

extension MenuViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Dabūt foto šūnu
        let cell = tableView.dequeueReusableCell(withIdentifier: Constance.Cells.mealTypeCell, for: indexPath) as! FoodTableViewCell
        
        //Dabūt bildi priekš tās linijas
        let photo = photos[indexPath.row]
        
        //Uzlikt detaļas šūnai
        cell.setPhoto(photo)
        
        return cell
    }
    
    
    
    
}
