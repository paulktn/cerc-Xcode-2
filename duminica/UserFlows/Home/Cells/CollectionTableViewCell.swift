//
//  CollectionTableViewCell.swift
//  duminica
//
//  Created by Olexa Boyko on 02.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    public var dataSource: PostsCollectionDataSource? {
        didSet {
            collectionView.dataSource = dataSource
            dataSource?.collectionView = collectionView
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataSource = nil
    }
}
