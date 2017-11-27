//
//  SocialMedia.swift
//  duminica
//
//  Created by paul catana on 9/2/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Social
import UIKit

public protocol SocialMediaShareable {
    func image() -> UIImage?
    func url() -> URL?
    func text() -> String?
}

public class SocialMediaSharingManager {
    public static func shareOnFacebook(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object, for: SLServiceTypeFacebook, from: presentingVC)
    }
    public static func shareOnTwitter(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object, for: SLServiceTypeTwitter, from: presentingVC)
    }
    private static func share(object: SocialMediaShareable, for serviceType: String, from presentingVC: UIViewController) {
        if let composeVC = SLComposeViewController(forServiceType:serviceType) {
            composeVC.add(object.image())
            composeVC.add(object.url())
            composeVC.setInitialText(object.text())
            presentingVC.present(composeVC, animated: true, completion: nil)
        }
    }
}

class ShareablePost: SocialMediaShareable {
    private let imageObj: UIImage?
    private let urlObj: URL?
    private let textObj: String?
    
    init(image: UIImage?, url: URL?, text: String?) {
        self.imageObj = image
        self.urlObj = url
        self.textObj = text
    }
    
    // MARK: – SocialMediaSharable
    func image() -> UIImage? {
        return self.imageObj
    }
    
    func url() -> URL? {
        return self.urlObj
    }
    
    func text() -> String? {
        return self.textObj
    }
}
