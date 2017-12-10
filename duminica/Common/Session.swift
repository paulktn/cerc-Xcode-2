//
//  Session.swift
//  duminica
//
//  Created by Oleg Chuchman on 10.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Session {
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            
            UserDefaults.standard.set(["name": user.name,
                                       "email": user.email,
                                       "id": user.id],
                                      forKey: "SessionUser")
            
        }
    }
    
    var lastLocation: CLLocationCoordinate2D?
    
    public init() {
        if let dict = UserDefaults.standard.value(forKey: "SessionUser") as? [String: String],
            let name = dict["name"],
            let email = dict["email"],
            let id = dict["id"] {
            user = User(name: name, email: email, id: id)
        } else if let id = Auth.auth().currentUser?.uid {
            loginWith(id: id)
        }
    }
    
    public func loginWith(id: String) {
        User.info(forUserID: id) { (user) in
            self.user = user
        }
    }
    
}

extension Session {
    struct FirebasePath {
        static let CONVERSATIONS_KEY = "ios_conversations"
        static let USERS_KEY = "ios_users"
        static let USER_CREDENTIALS = "credentials"
        static let USER_CONVERSATIONS_KEY = "user_conversations"
        static let CONVERSATION_POST_ID_KEY = "post_id"
    }
}
