//
//  ImageLoader.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import Foundation
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
let activityView = UIActivityIndicatorView(style: .large)

extension UIImageView {
  func loadRemoteImageFrom(urlString: String){
    let url = URL(string: urlString)
    image = nil
    activityView.center = self.center
    self.addSubview(activityView)
    activityView.startAnimating()
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        activityView.stopAnimating()
        activityView.removeFromSuperview()
        return
    }
    URLSession.shared.dataTask(with: url!) {
        data, response, error in
        DispatchQueue.main.async {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
        }
          if let response = data {
              DispatchQueue.main.async {
                if let imageToCache = UIImage(data: response) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }else{
                    print("Image still loading. Please wait. API's max calls may have been reached!")
                }
              }
          }
     }.resume()
  }
}

