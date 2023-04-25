//
//  UIImageView+Cache.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        
        
        
        guard let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) else {
            
            self.image = placeholder
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode, let image = UIImage(data: data) else { return }
                
                let cachedData = CachedURLResponse(response: httpResponse, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }.resume()
           return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}
