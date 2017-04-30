//
//  CustomImageView.swift
//  Firegram
//
//  Created by Nithin Reddy Gaddam on 4/29/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        guard let url = URL(string: urlString) else {return}
        
        lastUrlUsedToLoadImage = urlString
        
        if let cacheImage = imageCache[urlString]{
            self.image = cacheImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err{
                print("Failed to fetch post image:", err)
                return
            }
            //stops loading duplicate image load
            if url.absoluteString != self.lastUrlUsedToLoadImage {
                return
            }
            
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
        
    }
}
