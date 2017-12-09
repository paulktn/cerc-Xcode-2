//
//  extensionViewPost.swift
//  duminica
//
//  Created by paul catana on 9/9/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit

extension ViewPostVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
        layout.minimumInteritemSpacing = 04
        layout.minimumLineSpacing = 04
        layout.invalidateLayout()
        return CGSize(width: ((self.view.frame.width/2.2) - 6), height: ((self.view.frame.width / 2.2) - 6))
    }
}
