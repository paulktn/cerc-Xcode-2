//
//  CustomLabel.swift
//  GiveMain
//
//  Created by paul catana on 2/15/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    
}
