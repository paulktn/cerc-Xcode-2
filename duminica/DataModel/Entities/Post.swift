//
//  Post.swift
//  duminica
//
//  Created by Olexa Boyko on 26.11.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    //  MARK: - Stored Properties
    
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
    
    var postId: String
    var userId: String
    var postImageURL1: String
    var postImageURL2: String
    var postImageURL3: String
    var postThumbURL: String
    var ref: DatabaseReference!
    var key: String = ""
    var postDate: NSNumber
    var location: String
    var postTitle: String
    var postDetails: String
    var category: Category
    var allPosts: String
    var city: String
    var latit: Double
    var longit: Double
    
    //  MARK: - Computed Properties
    
    var serialized: [String: AnyObject] {
        return ["allPosts":self.allPosts as AnyObject,  "postId":self.postId as AnyObject,"postDate":self.postDate,"postImageURL1":self.postImageURL1 as AnyObject,"postImageURL2":self.postImageURL2 as AnyObject,"postImageURL3":self.postImageURL3 as AnyObject, "postThumbURL":self.postThumbURL as AnyObject, "userId":self.userId as AnyObject, "location":self.location as AnyObject, "postTitle":self.postTitle as AnyObject, "postDetails":self.postDetails as AnyObject, "postCategory":self.category.rawValue as AnyObject, "city":self.city as AnyObject, "latit": self.latit as AnyObject, "longit": self.longit as AnyObject]
    }
    
    //  MARK: - Initializers
    
    init(allPosts: String, postId: String, userId: String, postImageURL1: String, postImageURL2: String, postImageURL3: String,  postThumbURL: String,  postDate: NSNumber, key: String = "", location: String, postTitle: String, postDetails: String, postCategory: String, city: String, latit: Double, longit: Double){
        self.postId = postId
        self.postDate = postDate
        self.postImageURL1 = postImageURL1
        self.postImageURL2 = postImageURL2
        self.postImageURL3 = postImageURL3
        self.postId = postId
        self.userId = userId
        self.postThumbURL = postThumbURL
        self.location = location
        self.postTitle = postTitle
        self.postDetails = postDetails
        self.category = Category(rawValue: postCategory) ?? .unknown
        self.allPosts = allPosts
        self.city = city
        self.latit = latit
        self.longit = longit
        
    }
    
    init(snapshot:DataSnapshot) {
        self.userId = (snapshot.value! as! NSDictionary)["userId"] as! String
        
        self.postId = (snapshot.value! as! NSDictionary)["postId"] as! String
        
        self.postDate = (snapshot.value! as! NSDictionary)["postDate"] as! NSNumber
        self.postImageURL1 = (snapshot.value! as! NSDictionary)["postImageURL1"] as! String
        self.postImageURL2 = (snapshot.value! as! NSDictionary)["postImageURL2"] as! String
        self.postThumbURL = (snapshot.value! as! NSDictionary)["postThumbURL"] as! String
        self.postImageURL3 = (snapshot.value! as! NSDictionary)["postImageURL3"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.location = (snapshot.value! as! NSDictionary)["location"] as! String
        self.postTitle = (snapshot.value! as! NSDictionary)["postTitle"] as! String
        self.postDetails = (snapshot.value! as! NSDictionary)["postDetails"] as! String
        if let dict = snapshot.value as? NSDictionary,
            let categoryString = dict["postCategory"] as? String,
            let category = Category(rawValue: categoryString) {
            self.category = category
        } else {
            self.category = .unknown
        }
        
        self.allPosts = (snapshot.value! as! NSDictionary)["allPosts"] as! String
        self.city = (snapshot.value! as! NSDictionary)["city"] as! String
        self.latit = (snapshot.value! as! NSDictionary)["latit"] as! Double
        self.longit = (snapshot.value! as! NSDictionary)["longit"] as! Double
    }
}
