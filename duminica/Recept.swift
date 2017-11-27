//
//  Recept.swift
//  duminica
//
//  Created by paul catana on 8/29/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import Firebase

class Recept {
    var donorName: String
    var receptNumber: String
    var date: String
    var values: String
    var description: String
    var emailForRecept: String
    var ref: DatabaseReference!
    
    init(donorName: String, receptNumber: String, date: String, description: String, values: String, emailForRecept: String) {
        
        self.emailForRecept = emailForRecept
        self.donorName = donorName
        self.date = date
        self.receptNumber = receptNumber
        self.values = values
        self.description = description
        self.ref = Database.database().reference()
    }
    
    init(snapshot:DataSnapshot) {
        
        self.emailForRecept = (snapshot.value! as! NSDictionary)["emailForRecept"] as! String
        self.donorName = (snapshot.value! as! NSDictionary)["donorName"] as! String
        self.date = (snapshot.value! as! NSDictionary)["date"] as! String
        self.receptNumber = (snapshot.value! as! NSDictionary)["receptNumber"] as! String
        self.values = (snapshot.value! as! NSDictionary)["values"] as! String
        self.description = (snapshot.value! as! NSDictionary)["description"] as! String
        
    }
    
    func toAnyObject()->[String: AnyObject] {
        
        return ["donorName":self.donorName as AnyObject, "date":self.date as AnyObject, "receptNumber": self.receptNumber as AnyObject, "values":self.values as AnyObject, "description": self.description as AnyObject, "emailForRecept":self.emailForRecept as AnyObject
        ]
    }
    
    
    
}
