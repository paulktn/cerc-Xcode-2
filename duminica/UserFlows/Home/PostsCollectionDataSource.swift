//
//  PostsCollectionCollectionManager.swift
//  duminica
//
//  Created by Olexa Boyko on 03.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit

protocol PostsCollectionCollectionManagerDelegate: class {
    func selectedPost(_ post: Post)
}

class PostsCollectionCollectionManager: NSObject {
    weak var collectionView: UICollectionView?
    weak var delegate: PostsCollectionCollectionManagerDelegate?
    var posts: [Post] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
}

extension PostsCollectionCollectionManager: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionItemCell", for: indexPath) as? CollectionItemCell {
            
            cell.itemImageView.sd_setImage(with: URL(string: post.postImageURL1))
            cell.itemTitleLabel.text = post.postTitle
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension PostsCollectionCollectionManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        
        delegate?.selectedPost(post)
    }
}
