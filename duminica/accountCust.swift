//
//  accountCust.swift
//  GiveMain
//
//  Created by paul catana on 3/14/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase

class accountCust : UICollectionViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var titleCell: CustomLabel!
    @IBOutlet weak var markAsPickedUp: UIButton!
    @IBOutlet weak var viewItem: UIButton!

    func configureCell(post: Post) {
        
        self.dateCell.textColor = UIColor.white
    }
}

class wishCust: UICollectionViewCell{
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    
    func configureCell(post: Post) {
        self.dateCell.textColor = UIColor.white
    }
}
