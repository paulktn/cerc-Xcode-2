//
//  VideoCell.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Firebase

protocol custCellProtocol {
    func configureCell(post: Post) -> String
}

class custCell : UICollectionViewCell {
    var delegate: custCellProtocol?

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCell: UILabelX!
    @IBOutlet weak var dateCell: UILabelX!
    
    func configureCell(post: Post) {
        self.titleCell.text = ("\(post.city)")
        self.imageCell.layer.cornerRadius = 8
        self.titleCell.alpha = 1
        self.dateCell.alpha = 1
    }
}
    
    
    
    
    
    
  
    
    
    
    
    
    



