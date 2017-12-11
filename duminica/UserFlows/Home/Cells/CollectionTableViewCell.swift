//
//  CollectionTableViewCell.swift
//  duminica
//
//  Created by Oleg Chuchman on 02.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    public var collectionManager: PostsCollectionCollectionManager? {
        didSet {
            collectionView.dataSource = collectionManager
            collectionView.delegate = collectionManager
            collectionManager?.collectionView = collectionView
            collectionView.reloadData()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        collectionManager = nil
    }
}
