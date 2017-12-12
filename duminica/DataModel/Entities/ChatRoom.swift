//
//  ChatRoom.swift
//  duminica
//
//  Created by Oleg Chuchman on 12.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom {
    var lastMessage: String?
    var lastMessageDate: Date?
    var id: String
    var post: Post?
    
    init?(snapshot:DataSnapshot) {
        guard let data = snapshot.value as? NSDictionary else {return nil}
        self.id = snapshot.key
        if let messageId = data["last_message_id"] as? String {
            let messageRef = Database.database().reference().child("ios_conversations").child(self.id).child("messages").child(messageId)
            messageRef.observe(.value, with: { (snapshot) in
                guard let data = snapshot.value as? NSDictionary else {return}
                self.lastMessage = data["text"] as? String
                let timestamp = data["date_timestamp"] as! TimeInterval
                self.lastMessageDate = Date.init(timeIntervalSince1970: timestamp)
            })
        }
        if let postId = data["post_id"] as? String {
            let postRef = Database.database().reference().child("ios_posts").child(postId)
            postRef.observe(.value, with: { (snapshot) in
                self.post = Post.init(snapshot: snapshot)!
            })
        }
    }
}
