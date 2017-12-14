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
import FBSDKLoginKit

class User: NSObject {
    
    // MARK: - Properties
    
    let name: String
    let email: String
    let id: String
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, avatar: UIImage, completion: @escaping (String?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let storageRef = Storage.storage().reference()
                let postImageMetadata = StorageMetadata()
                postImageMetadata.contentType = "image/jpeg"
                let imageData = UIImageJPEGRepresentation(avatar, 0.6)
                let avatarPath = "userAvatar/\(withName)/image.jpg"
                let avatarRef = storageRef.child(avatarPath)
                let values = ["name": withName, "email": email]
                Database.database().reference().child("ios_users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (error, _) in
                    if error == nil {
                        avatarRef.putData(imageData!, metadata: postImageMetadata) { (newPostImageMD, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }else {
                                if let avatarURL = newPostImageMD?.downloadURL()
                                {
                                    let iosPostRef = Database.database().reference().child("ios_users").child((user?.uid)!).child("credentials")
                                    iosPostRef.child("avatar").setValue(avatarURL.absoluteString)
                                }
                            }
                        }
                        AppDelegate.session.loginWith(id: user!.uid)
                        completion(nil)
                    }
                })
            }
            else {
                completion(error?.localizedDescription)
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (String?) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                AppDelegate.session.loginWith(id: user!.uid)
                completion(nil)
            } else {
                completion(error?.localizedDescription)
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
        Database.database().reference().child(Session.FirebasePath.USERS_KEY).child(forUserID).child(Session.FirebasePath.USER_CREDENTIALS).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let user = User.init(name: name, email: email, id: forUserID)
                completion(user)
            }
        })
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
            }
        })
    }
    
    class func loginWithFB(viewController: UIViewController,
                           completion: ((LoginResult) -> ())?) {
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if error != nil {
                completion?(.failed)
            } else if (result?.isCancelled)! {
                completion?(.cancelled)
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if error == nil {
                        let values = ["name": user?.displayName ?? "", "email": user?.email ?? ""]
                        Database.database().reference().child("ios_users").child((user?.uid)!).child("credentials").setValue(values)
                        AppDelegate.session.loginWith(id: user!.uid)
                        completion?(.success)
                    }
                }
            }
        }
        
        
        
        
    }
    
//    class func loginWithFacebook(viewController: UIViewController,
//                                  completion: ((LoginResult) -> ())?) {
//
//        let manager = FBSDKLoginManager()
//        manager.logIn([.publicProfile], viewController: viewController) { (result) in
//                                switch result {
//                                case .cancelled:
//                                    completion?(.cancelled, nil)
//                                case .failed:
//                                    completion?(.failed, nil)
//                                case .success(grantedPermissions: _,
//                                              declinedPermissions: _,
//                                              token: let token):
//                                    self.fbToken = token.authenticationToken
//                                    let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
//                                    print(credential.provider, credential, token.authenticationToken)
//                                    Auth.auth().signIn(with: credential) { (user, error) in
//                                        if let error = error {
//                                            return
//                                        }
//                                        completion?(.success)
//                                    }
//                                }
//                        })
//        }
//            .logIn([.publicProfile, .email],
//                   viewController: viewController,
//                   completion: { result in
//                    switch result {
//                    case .cancelled:
//                        completion?(.cancelled, nil)
//                    case .failed:
//                        completion?(.failed, nil)
//                    case .success(grantedPermissions: _,
//                                  declinedPermissions: _,
//                                  token: let token):
//                        self.fbToken = token.authenticationToken
//                        let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
//                        print(credential.provider, credential, token.authenticationToken)
//                        Auth.auth().signIn(with: credential) { (user, error) in
//                            if let error = error {
//                                return
//                            }
//                            completion?(.success)
//                        }
//                    }
//            })
 //   }
    
    
    
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

public enum LoginResult {
    case success
    case cancelled
    case failed
}



