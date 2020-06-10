//
//  OrderFlowNavigationController.swift
//  OrderInn
//
//  Created by paulsnar on 05/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import Combine
import Foundation
import UIKit

class OrderFlowNavigationController: UINavigationController {
    @IBOutlet var statusPopover: UIView!
    @IBOutlet var orderSumm: UILabel!
    
    var hasLayout = false, isAnimating = false, isStatusPopoverShown = false
    private var orderCartStateSub: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderCartStateSub = OrderCart.shared.$state.sink { state in
            if state.quantity > 0 {
                if !self.isStatusPopoverShown {
                    self.showStatusPopover(completion: nil)
                }
                self.orderSumm.text = state.total.asString()
            } else {
                if self.isStatusPopoverShown {
                    self.hideStatusPopover(completion: nil)
                }
            }
        }
    }
    
    func showStatusPopover(completion: (() -> Void)?) {
        if isAnimating || isStatusPopoverShown {
            return
        }
        
        if !hasLayout {
            guard let window = view.window else { return }
            window.addSubview(statusPopover)
            statusPopover.translatesAutoresizingMaskIntoConstraints = false
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
        UIView.animate(withDuration: AnimationUtils.defaultDuration, animations: {
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
        UIView.animate(withDuration: AnimationUtils.defaultDuration, animations: {
            self.statusPopover.transform = CGAffineTransform(translationX: 0.0, y: self.statusPopover.bounds.height + 8.0)
        }, completion: { _ in
            self.isAnimating = false
            self.isStatusPopoverShown = false
            if let completion = completion {
                completion()
            }
        })
    }
    
    @IBAction func handleCheckoutTapped(_ sender: Any) {
        hideStatusPopover(completion: nil)
    }
    
}
