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

class ChatVCNew: JSQMessagesViewController {
    
    
    var items = [Message]()
    var currentUser: User?
    
    var myUser: UserInfo!
    var otherUser: UserInfo!
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    private var messageRef: DatabaseReference?
    private var userRef: DatabaseReference?
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
        messageRef = Database.database().reference().child("conversations")
        userRef = Database.database().reference().child("users")
//        self.userIsTypingRef = self.messageRef?.child("typingIndicator").child(self.senderId)
//        self.usersTypingQuery = self.messageRef?.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
        self.inputToolbar.contentView?.leftBarButtonItem?.imageView?.contentMode = .scaleAspectFill
        self.inputToolbar.contentView?.leftBarButtonItemWidth = 40
//        self.observeMessages()
//        self.observeTyping()
//        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.)
//        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: Color.FromRGB(rgbValue: 0x64D0BD))
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }
    
    private func addMessage(withId id: String, date: Date, name: String, text: String) {
        if let message = JSQMessage(senderId: id, senderDisplayName: name, date: date, text: text) {
            messages.append(message)
        }
    }
    
    //Downloads messages
    func fetchData() {
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
    }
    
    func composeMessage(content: Any)  {
        let message = Message.init(content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    
//    private func getUser() {
//        if let currentUser = Auth.auth().currentUser?.uid {
//            userRef?.child("credentials").observe(.value, with: { (snapshot) in
//                let userData = snapshot.value as! Dictionary<String, Any>
//
//                if let email = userData["email"] as? String,
//                    let name = userData["name"] as? String {
//                    self.myUser.email = email
//                    self.myUser.name = name
//                    self.myUser.id = currentUser
//                    self.senderDisplayName = name
//                    self.senderId = currentUser
//                }
//            })
//        }
//    }
    
    private func observeMessages() {
//        newMessageRefHandle = messageRef?.observe(.childAdded, with: { (snapshot) -> Void in
//            let messageData = snapshot.value as! Dictionary<String, Any>
//
//            if let id = messageData["senderId"] as? Int, let name = messageData["author"] as? String, let dateString = messageData["date"] as? String, let text = messageData["message"] as? String, text.characters.count > 0 {
//                let formatter = DateFormatter()
//                TimeZone.ReferenceType.default = TimeZone(abbreviation: "UTC")!
//                formatter.timeZone = TimeZone.ReferenceType.default
//                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                let dateDefault = formatter.date(from: dateString)
//                formatter.timeZone = TimeZone.current
//                let dateStringLocal = formatter.string(from: dateDefault ?? Date())
//                formatter.timeZone = TimeZone(abbreviation: "UTC")
//                let date = formatter.date(from: dateStringLocal)
//                self.addMessage(withId: "\(id)", date: date!, name: name, text: text)
//                self.finishReceivingMessage()
//            } else {
//                //print("Error! Could not decode message data")
//            }
//        })
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
//        let itemRef = messageRef?.childByAutoId()
//        let a = messageRef.child("conversations")
//        TimeZone.ReferenceType.default = TimeZone(abbreviation: "UTC")!
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.ReferenceType.default
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        let stringDate = formatter.string(from: date)
//        let messageItem = [
//            "author": self.room?.senderFirstName ?? "",
//            "date": stringDate,
//            "message": text,
//            "receiverId": self.room?.receiverId ?? 0,
//            "senderId": self.room?.senderId ?? 0,
//            ] as [String : Any]
//        ServerManager.sendLastMsg(lastMsg: text, lastMsgDate: stringDate, lastUserId: self.room?.senderId ?? 0, id: self.room?.id ?? 0)
//        itemRef?.setValue(messageItem)
//        JSQSystemSoundPlayer.jsq_playMessageSentSound()
//        isTyping = false
//        finishSendingMessage()
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
