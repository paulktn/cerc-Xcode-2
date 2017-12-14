//
//  UILabel+Common.swift
//  duminica
//
//  Created by Olexa Boyko on 14.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation

extension UILabel {
    static func heightFor(text:String, font:UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    static func widthFor(text:String, font:UIFont, height: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 1
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }
}
