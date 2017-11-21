//
//  File.swift
//  duminica
//
//  Created by paul catana on 8/27/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import Firebase

struct PickedUp {
    var postId: String
    var byUser: String
    var fromUser: String
    var itemValue: String
    var pickedDate: NSNumber
    var itemName: String
    var postImageURL1: String
    
    var ref: DatabaseReference!
    
    
    init(byUser: String, fromUser: String, itemValue: String, pickedDate: NSNumber, itemName: String, postImageURL1: String, postId: String) {
         self.postId = postId
        self.byUser = byUser
        self.fromUser = fromUser
        self.itemValue = itemValue
        self.itemName = itemName
        self.pickedDate = pickedDate
        self.postImageURL1 = postImageURL1
        self.ref = Database.database().reference()
    }
    
    init(snapshot:DataSnapshot) {
        
        self.byUser = (snapshot.value! as! NSDictionary)["byUser"] as! String
        self.fromUser = (snapshot.value! as! NSDictionary)["fromUser"] as! String
         self.byUser = (snapshot.value! as! NSDictionary)["byUser"] as! String
         self.itemName = (snapshot.value! as! NSDictionary)["itemName"] as! String
        self.itemValue = (snapshot.value! as! NSDictionary)["itemValue"] as! String
        self.pickedDate = (snapshot.value! as! NSDictionary)["pickedDate"] as! NSNumber
        self.postImageURL1 = (snapshot.value! as! NSDictionary)["postImageURL1"] as! String
     self.postId = (snapshot.value! as! NSDictionary)["postId"] as! String
    }
    
    
    func toAnyObject()->[String: AnyObject] {
        return [ "postId":self.postId as AnyObject, "byUser": self.byUser as AnyObject, "fromUser": self.fromUser as AnyObject, "itemValue": self.itemValue as AnyObject, "itemName":self.itemName as AnyObject, "postImageURL1":self.postImageURL1 as AnyObject, "pickedDate": self.pickedDate as AnyObject]
    }
    
    
}


