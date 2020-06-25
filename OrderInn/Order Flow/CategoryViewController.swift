//
//  CategoryViewController.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 30/05/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class CategoryViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var tableId, seatId: String?
    
    var categories = [MenuCategory]()
    let fireRef = Firestore.firestore()
    let transition = SlideTransition()
    var parallexOffsetSpeed: CGFloat = 80
    var cellHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        
        loadCategories { (categories) in
            self.categories = categories
            self.categories.sort(by: { (a, b) in a.order < b.order })
            self.tableView.reloadData()
        }
    }
    
    var parallexImageHeight:CGFloat{
        let maxOffset = sqrt(pow(cellHeight, 2) + 4 * parallexOffsetSpeed * self.tableView.frame.height)
        - cellHeight / 2
        return maxOffset + self.cellHeight
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
        
        guard let slideMenuVC = storyboard?.instantiateViewController(identifier: "SlideMenu") else {return}
        slideMenuVC.modalPresentationStyle = .overCurrentContext
        slideMenuVC.transitioningDelegate = self
        present(slideMenuVC, animated: true)
        
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

extension CategoryViewController: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


