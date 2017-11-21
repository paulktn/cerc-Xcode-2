//
//  TBCell.swift
//  GiveMain
//
//  Created by paul catana on 3/9/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit


class TBCell: UITableViewCell {
    
   // @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    func clearCellData()  {
        self.nameLabel.font = UIFont(name:"AvenirNext-Regular", size: 16.0)
        self.messageLabel.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        self.messageLabel.layer.cornerRadius = 20
        self.timeLabel.font = UIFont(name:"AvenirNext-Regular", size: 15.0)
        //self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
        self.messageLabel.textColor = UIColor.white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.profilePic.layer.borderWidth = 2
      //  self.profilePic.layer.borderColor = GlobalVariables.purple.cgColor
    }
    
}
///self.messageLabel.textColor = UIColor.rbg(r: 111, g: 113, b: 121)


class reportCell: UITableViewCell {
    
    
}
