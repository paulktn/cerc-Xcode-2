//
//  ChatManager.swift
//  duminica
//
//  Created by Oleg Chuchman on 10.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ChatManager {
    public static let shared = ChatManager()
    
    private var databaseReference = Database.database().reference()
    
    private init(){}
    
    public func initiateChat(with post: Post) -> String? {
        guard let myId = Auth.auth().currentUser?.uid else {return nil}
        
        let chat = databaseReference.child(Session.FirebasePath.CONVERSATIONS_KEY).childByAutoId()
        let chatId = chat.key
        chat.child(Session.FirebasePath.CONVERSATION_POST_ID_KEY).setValue(post.id)
        initChatFromUser(myId, to: post.ownerId, withChatId: chatId)
        initChatFromUser(post.ownerId, to: myId, withChatId: chatId)
        
        return chatId
    }
    
    // Passes ChatId in completion, nil if not exists
    public func checkIfChatExists(post: Post, completion: @escaping (String?) -> Void) {

        guard let myId = Auth.auth().currentUser?.uid else {return}

        databaseReference
            .child(Session.FirebasePath.USERS_KEY)
            .child(myId)
            .child(Session.FirebasePath.USER_CONVERSATIONS_KEY)
            .child(post.ownerId).observe(.value, with: { (snapshot) in
                completion(snapshot.value as? String)
            })
    }
    
    private func initChatFromUser(_ userFrom: String, to userTo: String, withChatId chatId: String) {
        databaseReference
            .child(Session.FirebasePath.USERS_KEY)
            .child(userFrom)
            .child(Session.FirebasePath.USER_CONVERSATIONS_KEY)
            .child(userTo)
            .setValue(chatId)
    }
}
