//
//  PresentDetailTransition.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 09/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit

class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        let detail = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        detail.view.alpha = 0.0
        
        var frame = containerView.bounds
        frame.origin.y += 20.0
        frame.size.height -= 20.0
        detail.view.frame = frame
        
        containerView.addSubview(detail.view)
        
        UIView.animateWithDuration(0.3, animations: {detail.view.alpha = 1.0}, completion: {
            finished in
            transitionContext.completeTransition(true)
            })
    }
}
