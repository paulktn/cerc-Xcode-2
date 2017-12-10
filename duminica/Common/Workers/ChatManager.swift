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

private let CONVERSATIONS_KEY = "ios_conversations"
private let USERS_KEY = "ios_users"
private let USER_CONVERSATIONS_KEY = "user_conversations"
private let CONVERSATION_POST_ID_KEY = "post_id"

class ChatManager {
    public static let shared = ChatManager()
    
    private var databaseReference = Database.database().reference()
    
    private init(){}
    
    public func initiateChat(with post: Post) -> String? {
        guard let myId = Auth.auth().currentUser?.uid else {return nil}
        
        let chat = databaseReference.child(CONVERSATIONS_KEY).childByAutoId()
        let chatId = chat.key
        chat.child(CONVERSATION_POST_ID_KEY).setValue(post.postId)
        initChatFromUser(myId, to: post.userId, withChatId: chatId)
        initChatFromUser(post.userId, to: myId, withChatId: chatId)
        
        return chatId
    }
    
    private func initChatFromUser(_ userFrom: String, to userTo: String, withChatId chatId: String) {
        databaseReference
            .child(USERS_KEY)
            .child(userFrom)
            .child(USER_CONVERSATIONS_KEY)
            .child(chatId)
            .setValue(userTo)
    }
}
