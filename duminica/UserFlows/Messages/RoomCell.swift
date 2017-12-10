//
//  RoomCell.swift
//  duminica
//
//  Created by Natali on 10.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var lastMessageTest: UILabel!
    @IBOutlet weak var lastMessageDate: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpCell(title: String,
                   lastMsg: String,
                   date: String,
                   image: UIImage){
        postTitle.text = title
        lastMessageTest.text = lastMsg
        lastMessageDate.text = date
        postImage.image = image
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = postImage.frame.height / 2
        postImage.layer.borderWidth = 1
        postImage.layer.borderColor = UIColor.black.cgColor
    }
    
}
