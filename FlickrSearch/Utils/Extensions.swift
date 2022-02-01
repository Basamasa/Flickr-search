//
//  Extensions.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    /// Load image from cache, else download
    func loadImageUsingCache(withUrl urlString : String) {
            let url = URL(string: urlString)
            if url == nil {return}
            self.image = nil

            if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
                self.image = cachedImage
                return
            }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
            addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.center = self.center

            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }

                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                        activityIndicator.removeFromSuperview()
                    }
                }

            }).resume()
        }
}
