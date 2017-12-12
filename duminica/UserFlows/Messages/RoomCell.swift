//
//  RoomCell.swift
//  duminica
//
//  Created by Natali on 10.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
    
    var room: ChatRoom!

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var lastMessageTest: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpCell(room: ChatRoom){
        lastMessageDate.text = getDate(date: room.lastMessageDate ?? Date())
        postTitle.text = room.post?.title
                self.room = room
        lastMessageTest.text = room.lastMessage
        guard let photoUrl = room.post?.imageURLs[0] else {
            return
        }
        postImage.sd_setImage(with: photoUrl)
    }
    
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        formatter.dateFormat = "MMMM d"
        let stringDate = formatter.string(from: date)
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            let stringDate = formatter.string(from: date)
            return stringDate
        }
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        return stringDate
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = postImage.frame.height / 2
        postImage.layer.borderWidth = 1
        postImage.layer.borderColor = UIColor.black.cgColor
    }
    
}
