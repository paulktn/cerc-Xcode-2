//
//  CustomizableButton.swift
//  Swiftify
//
//  Created by Frezy Mboumba on 12/17/16.
//  Copyright © 2016 Frezy Mboumba. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableButton: UIButton {

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
    
    @IBInspectable var borderColor: UIColor = UIColor.green {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }


}
