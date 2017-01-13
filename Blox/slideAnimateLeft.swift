//
//  slideAnimate.swift
//  Blox
//
//  Created by Jeffrey Li on 1/8/17.
//  Copyright © 2017 Jeffrey Li. All rights reserved.
//

import UIKit

class slideAnimateLeft: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.6
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        
        let screenOffLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        let screenOffRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.transform = screenOffLeft
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: [], animations: {
            
            fromView.transform = screenOffRight
            fromView.alpha = 0.7
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            
        }) { (success) in
            transitionContext.completeTransition(success)
        }
        
        
        
    }
    
}
