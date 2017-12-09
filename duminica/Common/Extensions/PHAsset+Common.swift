//
//  PHAsset+Common.swift
//  duminica
//
//  Created by Olexa Boyko on 09.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

extension PHAsset {
    var uiImage: UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image: UIImage?
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            image = result
        })
        
        return image
    }
}
