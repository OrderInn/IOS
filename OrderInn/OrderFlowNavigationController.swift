//
//  OrderFlowNavigationController.swift
//  OrderInn
//
//  Created by paulsnar on 05/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Foundation
import UIKit

class OrderFlowNavigationController: UINavigationController {
    @IBOutlet var statusPopover: UIView!
    @IBOutlet weak var orderSumm: UILabel!
    
    var hasLayout = false, isAnimating = false, isStatusPopoverShown = false
    
    func showStatusPopover(completion: (() -> Void)?) {
        if isAnimating || isStatusPopoverShown {
            return
        }
        guard let window = view.window else { return }
        statusPopover.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(statusPopover)
        
        if !hasLayout {
            statusPopover.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            statusPopover.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -8.0).isActive = true
            statusPopover.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 8.0).isActive = true
            statusPopover.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -8.0).isActive = true
            statusPopover.layer.cornerRadius = 5.0
            hasLayout = true
        }
        
        // animate float in
        statusPopover.transform = CGAffineTransform(translationX: 0.0, y: statusPopover.bounds.height + 8.0)
        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.statusPopover.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.isAnimating = false
            self.isStatusPopoverShown = true
            if let completion = completion {
                completion()
            }
        })
    }
    
    func hideStatusPopover(completion: (() -> Void)?) {
        if isAnimating || !isStatusPopoverShown {
            return
        }
        
        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.statusPopover.transform = CGAffineTransform(translationX: 0.0, y: self.statusPopover.bounds.height + 8.0)
        }, completion: { _ in
            self.isAnimating = false
            self.isStatusPopoverShown = false
            self.statusPopover.transform = .identity
            self.statusPopover.removeFromSuperview()
            if let completion = completion {
                completion()
            }
        })
    }
    
    @IBAction func handleCheckoutTapped(_ sender: Any) {
        hideStatusPopover(completion: nil)
    }
    
}
