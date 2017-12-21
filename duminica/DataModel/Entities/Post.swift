//
//  Post.swift
//  duminica
//
//  Created by Oleg Chuchman on 26.11.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import Firebase

class Post {
    enum Category: String {
        case clothingAndAccesories = "clothing & accesories"
        case electronics
        case furniture
        case householdItems = "household items"
        case appliances
        case toysAndGames = "toys & games"
        case homeImprovement = "home improvement"
        case miscellaneous
        case sportingGoods = "sporting goods"
        case constructionMaterials = "construction materials"
        case tools
        case unknown
        
        init?(string: String) {
            self.init(rawValue: string.lowercased())
        }
    }
    
    var id: String
    var title: String
    var details: String?
    var locationTitle: String?
    var longitude: Double
    var latitude: Double
    var category: Category
    var logoUrl: URL?
    var imageURLs: [URL] = []
    var ownerId: String
    var date: NSNumber
    var keywords: String?
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    convenience init?(snapshot:DataSnapshot) {
        guard let data = snapshot.value as? NSDictionary else {return nil}
        self.init(dict: data, id: snapshot.key)
    }
    
    init?(dict data: NSDictionary, id: String) {
        self.id = id
        self.details = data["details"] as? String
        self.locationTitle = data["location_title"] as? String
        self.title = data["title"] as? String ?? ""
        self.ownerId = data["owner_id"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
        self.date = data["date"] as! NSNumber
        self.keywords = data["keywords"] as? String
        if let categoryString = data["category"] as? String,
            let category = Category(string: categoryString) {
            self.category = category
        } else {
            self.category = .unknown
        }
        if let logoUrlString = data["logo_url"] as? String,
            let logoUrl = URL(string: logoUrlString) {
            self.logoUrl = logoUrl
        }
        if let imagesDictionary = data["images"] as? NSDictionary {
            imagesDictionary.forEach({(_, value) in
                if let limgUrlString = value as? String,
                    let imgUrl = URL(string: limgUrlString) {
                    self.imageURLs.append(imgUrl)
                }
            })
        }
    }
}
