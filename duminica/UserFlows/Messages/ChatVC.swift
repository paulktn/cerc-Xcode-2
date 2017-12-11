//
//  ChatVC.swift
//  duminica
//
//  Created by Natali on 09.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import JSQMessagesViewController
import UIKit
import Firebase
import FirebaseDatabase

class ChatVC: JSQMessagesViewController {

    var post: Post!
    var roomId: String!
    var currentUser: User?
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    private var messageRef: DatabaseReference?
    private var newMessageRefHandle: DatabaseHandle?
    private var userIsTypingRef: DatabaseReference?
    private var usersTypingQuery: DatabaseQuery?
    
    
    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef?.setValue(newValue)
        }
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        messageRef = Database.database().reference().child("ios_conversations").child(roomId)
        observeMessages()
        self.userIsTypingRef = self.messageRef?.child("typingIndicator").child(self.senderId)
        self.usersTypingQuery = self.messageRef?.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
        self.inputToolbar.contentView?.leftBarButtonItem?.imageView?.contentMode = .scaleAspectFill
        self.inputToolbar.contentView?.leftBarButtonItemWidth = 40
        self.observeTyping()
        self.title = post.title
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.black)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.black)
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    private func getCurrentUser() {
        if let id = Auth.auth().currentUser?.uid {
            self.senderId = id
            self.senderDisplayName = currentUser?.name ?? "no name"
        }
    }
    
    private func addMessage(withId id: String, date: Date, name: String, text: String) {
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text) {
            messages.append(message)
        }
    }
    
    private func observeMessages() {
        messageRef?.child("messages").observe(.childAdded, with: { (snapshot) in
            let messageData = snapshot.value as! Dictionary<String, Any>
            if let id = messageData["senderId"] as? String, let name = messageData["senderName"] as? String, let dateTimestamp = messageData["date_timestamp"] as? TimeInterval, let text = messageData["text"] as? String, text.count > 0 {
                let date = Date.init(timeIntervalSince1970: dateTimestamp)
                self.addMessage(withId: id, date: date, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                //print("Error! Could not decode message data")
            }
        })
    }
    
    private func observeTyping() {
        let typingIndicatorRef = messageRef?.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef?.child(senderId)
        userIsTypingRef?.onDisconnectRemoveValue()
        usersTypingQuery?.observe(.value) { (data: DataSnapshot) in
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let dafaultOffset: CGFloat = 8
        let top = dafaultOffset + kJSQMessagesCollectionViewCellLabelHeightDefault + (navigationController?.navigationBar.bounds.size.height ?? 0)
        
        return UIEdgeInsetsMake(top, 0, dafaultOffset, 0)
    }
    
    //MARK: Actions
    override func didPressAccessoryButton(_ sender: UIButton) {
        
        
        
    }
    
    override func didPressSend(_ button: UIButton,
                               withMessageText text: String,
                               senderId: String,
                               senderDisplayName: String,
                               date: Date) {
        let itemRef = messageRef?.child("messages").childByAutoId()
        let messageItem = [
            "date_timestamp": date.timeIntervalSince1970,
            "text": text,
            "senderName": senderDisplayName,
            "senderId": senderId,
            "is_read": false] as [String : Any]
        messageRef?.child("last_message_id").setValue(itemRef?.key)
        itemRef?.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        isTyping = false
        finishSendingMessage()
    }
    
    
    //MARK: CollectionView
    
    //func collectionViewJSQMessages
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            let text = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            let txt = NSMutableAttributedString.init(attributedString: text!)
            txt.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 11)], range: (txt.string as NSString).range(of: txt.string))
            return txt
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if messages[indexPath.row].senderId == self.senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping = textView.text != ""
    }
    
}

