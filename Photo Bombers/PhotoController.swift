//
//  PhotoController.swift
//  Photo Bombers
//
//  Created by Dino Paskvan on 09/06/14.
//  Copyright (c) 2014 Dino Paskvan. All rights reserved.
//

import UIKit

class PhotoController: NSObject {
    class func imageForPhoto(photo: NSDictionary, size: String, completion: ((UIImage!) -> Void)?) {
        let id: String = photo["id"] as String
        let key = "\(id)-\(size)"
        let photoCache: UIImage? = SAMCache.sharedCache().imageForKey(key)
        if photoCache {
            completion!(photoCache)
        }
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: photo["images"]![size]!["url"]! as NSString)
        let request = NSURLRequest(URL: url)
        let task = session.downloadTaskWithRequest(request, completionHandler: {
            location, response, error in
            let data = NSData(contentsOfURL: location)
            let image = UIImage(data: data)
            SAMCache.sharedCache().setImage(image, forKey: key)
            
            dispatch_async(dispatch_get_main_queue(), {
                completion!(image)
                })
            })
        task.resume()
    }
}
