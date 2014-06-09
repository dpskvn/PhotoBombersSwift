//
//  PhotoCell.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 08/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView
    var photoSet: NSDictionary?
    var photo: NSDictionary? {
    set {
        photoSet = newValue
        PhotoController.imageForPhoto(photoSet!, size: "thumbnail", completion: {
            image in
            self.imageView.image = image
            })
    }
    get {
        return photoSet
    }
    }
    
    init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: NSSelectorFromString("like"))
        tap.numberOfTapsRequired = 2
        
        self.addGestureRecognizer(tap)
        
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    func downloadPhotoWithURL(url: NSURL) {
        let id: String = photoSet!["id"] as String
        let key = "\(id)-thumbnail"
        let photoCache: UIImage? = SAMCache.sharedCache().imageForKey(key)
        if photoCache {
            imageView.image = photoCache
        }
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request, completionHandler: {
            location, response, error in
            let data = NSData(contentsOfURL: location)
            let image = UIImage(data: data)
            SAMCache.sharedCache().setImage(image, forKey: key)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = image;
                })
            })
        task.resume()
    }
    
    func like() {
        let session = NSURLSession.sharedSession()
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as String
        let id: String = photoSet!["id"] as String
        let url = NSURL(string: "https://api.instagram.com/v1/media/\(id)/likes?access_token=\(accessToken)")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            dispatch_async(dispatch_get_main_queue(), {
                self.showLikeCompletion()
                })
            })
        task.resume()
    }
    
    func showLikeCompletion() {
        let alert = UIAlertView()
        alert.title = "Liked"
        alert.show()
        
        let delayInNanoSeconds: Int64 = 1000000000
        let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInNanoSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(0, animated: true)
            })
    }
}
