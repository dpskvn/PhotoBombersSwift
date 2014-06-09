//
//  DismissDetailTransition.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 09/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit

class DismissDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        let detail = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        UIView.animateWithDuration(0.3, animations: {detail.view.alpha = 0.0}, completion: {
            finished in
            detail.view.removeFromSuperview()
            transitionContext.completeTransition(true)
            })
    }
}
