//
//  Extensions.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    /**
     Load image from cache, or else download from internet
     
     - Parameters:
        - urlString: Url string
     */
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

extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}
