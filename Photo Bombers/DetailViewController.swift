//
//  DetailViewController.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 09/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        
        imageView = UIImageView(frame: CGRectMake(0.0, -320.0, 320.0, 320.0))
        view.addSubview(imageView)
        
        PhotoController.imageForPhoto(photo!, size: "standard_resolution", completion: {
            image in
            self.imageView!.image = image
            })
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    override func viewDidAppear(animated: Bool) {
        let snap = UISnapBehavior(item: imageView, snapToPoint: view.center)
        animator!.addBehavior(snap)
    }
    
    func close () {
        animator!.removeAllBehaviors()
        let snap = UISnapBehavior(item: imageView, snapToPoint: CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMaxY(view.bounds) + 180.0))
        animator!.addBehavior(snap)
        self.dismissViewControllerAnimated(true, completion: {})
    }
}
