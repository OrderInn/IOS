//
//  CategoryViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import OrderInnAPIKit

class CategoryViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var tableId, seatId: String?
    
    var categories = [MenuCategory]()
    var parallexOffsetSpeed: CGFloat = 80
    var cellHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        
        loadCategories { categories in
            DispatchQueue.main.async {
                self.categories = categories
                self.categories.sort(by: { (a, b) in a.order < b.order })
                self.tableView.reloadData()
            }
        }
    }
    
    var parallexImageHeight:CGFloat{
        let maxOffset = sqrt(pow(cellHeight, 2) + 4 * parallexOffsetSpeed * self.tableView.frame.height)
        - cellHeight / 2
        return maxOffset + self.cellHeight
    }

    func loadCategories(_ completion: @escaping ([MenuCategory]) -> Void) {
        Client.shared.getMenu(for: restaurant!.apiKit!) { categories, items, error in
            guard error == nil else {
                // TODO should actually do something here
                log("Failed to load menu: %@", String(describing: error))
                return
            }
            completion(categories!.map { MenuCategory(from: $0) })
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
        cell.parallexTopHeight.constant = parallexImageHeight
        cell.parallexTop.constant = parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
        return cell
    }
    
    // MARK: Segue Data Passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? MenuCategoryCell else { return }
        let category = cell.category!
        if let menuItemVC = segue.destination as? MenuItemViewController {
            menuItemVC.restaurant = restaurant!
            menuItemVC.category = category
        }
    }

    
    @IBAction func didTapSlideMenu(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    func parallaxOffset(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat{
           return(newOffsetY - cell.frame.origin.y) / parallexImageHeight * parallexOffsetSpeed
       }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _ = tableView.contentOffset.y
        for cell in tableView.visibleCells as! [MenuCategoryCell]{
            cell.parallexTop.constant = parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
        }
    }
}



