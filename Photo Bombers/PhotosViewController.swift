//
//  PhotosViewController.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 08/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit


let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    
    var accessToken: String
    var photos: NSArray = NSArray()

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(106.0, 106.0)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        accessToken = userDefaults.objectForKey("accessToken") ? userDefaults.objectForKey("accessToken") as String : ""
        
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Bombers"
        
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: "photo")
        collectionView.backgroundColor = UIColor.whiteColor()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if accessToken == "" {
        
            SimpleAuth.authorize("instagram", options: ["scope": ["likes"]], completion: {
                responseObject, error in
                self.accessToken = responseObject.objectForKey("credentials").objectForKey("token") as String
                
                userDefaults.setObject(self.accessToken, forKey: "accessToken")
                
                userDefaults.synchronize()
                
                self.refresh()
                })
        } else {
            refresh()
        }
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> PhotoCell! {
        let cell:PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath) as PhotoCell
        
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.photo = photos[indexPath.row] as? NSDictionary
        return cell
    }
    
    func refresh() {
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: "https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=\(accessToken)")
        
        let request = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request, completionHandler: {
            location, response, error in
            let data = NSData(contentsOfURL: location)
            
            let responseDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            
            self.photos = responseDictionary.valueForKeyPath("data") as NSArray
            
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView.reloadData()
                })
            
            })
        task.resume()
    }
    
    override func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        let photo = photos[indexPath.row] as NSDictionary
        let viewController: DetailViewController = DetailViewController()
        viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        viewController.transitioningDelegate = self
        viewController.photo = photo
        self.presentViewController(viewController, animated: true, completion: {})
    }
    
    func animationControllerForPresentedController(presented: UIViewController!,
        presentingController presenting: UIViewController!,
        sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
            return PresentDetailTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return DismissDetailTransition()
    }
}
