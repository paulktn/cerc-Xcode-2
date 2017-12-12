//
//  ReusableCell.swift
//  duminica
//
//  Created by Olexa Boyko on 12.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation

protocol ReusableCell where Self: UICollectionViewCell {
    static var reuseIdentifier: String {get}
}

extension ReusableCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
