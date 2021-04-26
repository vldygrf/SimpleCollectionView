//
//  Image.swift
//  SimpleCollectionView
//
//  Created by Vladislav Garifulin on 25.04.2021.
//

import Foundation

struct Image {
    var path: String
  
    init(path: String) {
        self.path = path
    }
    
    private static let cache = NSCache<NSString, NSData>()
    
    private static func allItems() -> [Image] {
        return [
            Image(path: "https://cdn.pixabay.com/photo/2020/12/10/09/22/beach-front-5819728_1280.jpg"),
            Image(path: "https://cdn.pixabay.com/photo/2021/04/05/14/54/meerkats-6153748_1280.jpg"),
            Image(path: "https://cdn.pixabay.com/photo/2021/04/20/17/05/adler-6194438_1280.jpg"),
            Image(path: "https://cdn.pixabay.com/photo/2021/04/13/19/41/elephants-6176590_1280.jpg"),
            Image(path: "https://cdn.pixabay.com/photo/2020/09/02/11/04/landscape-5538015_1280.jpg"),
            Image(path: "https://cdn.pixabay.com/photo/2020/11/07/13/07/waves-5720916_1280.jpg")
        ]
    }
    
    static var items: [Image] = {
        return allItems()
    }()
    
    static func setAllItems() {
        items = allItems()
    }
    
    func get(completion: @escaping (_ imageData: Data?, _ error: Error?) -> Void) {
        if let imageData = Image.cache.object(forKey: path as NSString) {
            completion(imageData as Data, nil)
            return
        }
        
        guard let url = URL(string: path) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let imageData = data, error == nil
            else {
                completion(nil, error)
                return
            }

            Image.cache.setObject(imageData as NSData, forKey: path as NSString)
            completion(data, nil)
        }.resume()
    }
}
