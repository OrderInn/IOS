//
//  SlideTransition.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 23/06/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit

class SlideTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewcontroller = transitionContext.viewController(forKey: .from) else {return}
        
        let containerView  = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.7
        let finalHight = toViewController.view.bounds.height
        
        if isPresenting{
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: -finalHight, y: 0, width: finalWidth, height: finalHight)
        }
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        let identety = {
            self.dimmingView.alpha = 0.0
            fromViewcontroller.view.transform = .identity
        }
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identety()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
}
