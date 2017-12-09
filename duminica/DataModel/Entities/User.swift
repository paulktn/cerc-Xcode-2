//
//  User.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/16/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User: NSObject {
    
    // MARK: - Properties
    
    let name: String
    let email: String
    let id: String
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                
                let values = ["name": withName, "email": email]
                Database.database().reference().child("ios_users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : email, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        completion(true)
                    }
                })
            }
                
            else {
                completion(false)
                print("nope")
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("ios_users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let user = User.init(name: name, email: email, id: forUserID)
                completion(user)
            }
        })
    }
    
    
    
    func fetchCurrentUser(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        
        let currentUser = Auth.auth().currentUser!
        
        let currentUserRef = Database.database().reference().child("ios_users").child(forUserID).child(currentUser.uid).child("credentials")
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let id = currentUser.key
            let data = currentUser.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != forUserID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let user = User.init(name: name, email: email, id: id)
                completion(user)
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("ios_users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let user = User.init(name: name, email: email, id: id)
                completion(user)
            }})}
    
    
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })}
    
    
    //MARK: Inits
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
       
    }
}



