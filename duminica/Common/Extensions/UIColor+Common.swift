//
//  UIColor+Common.swift
//  duminica
//
//  Created by Olexa Boyko on 26.11.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    private class func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
    
    static var duminicaBlue: UIColor {
        return .rgb(r: 129, g: 144, b: 255)
    }
    
    static var duminicaPurple: UIColor {
        return .rgb(r: 161, g: 114, b: 255)
    }
}
