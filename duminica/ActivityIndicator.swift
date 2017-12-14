//
//  ActivityIndicator.swift
//  dojo
//
//  Created by Rostyk on 12.07.17.
//  Copyright © 2017 dayton marketing. All rights reserved.
//

import Foundation
import UIKit

final class ActivityIndicator: UIView {
    static let shared = ActivityIndicator(frame: .zero)
    
    private override init(frame: CGRect) {
        
        self.spinner = UIImageView(image: UIImage(named: "Spinner"))
        self.rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        super.init(frame: frame)
        
        // hexagon
        spinner.frame = CGRect(x: bounds.size.width / 2.0 - 40, y: bounds.size.height / 2.0 - 40, width: 80.0, height: 80.0)
        spinner.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
        spinner.contentMode = .scaleAspectFit
        addSubview(spinner)
        // logo
        let logo = UIImageView(image: UIImage(named: "AssetLogo"))
        logo.frame = CGRect(x: bounds.size.width / 2.0 - 30, y: bounds.size.height / 2.0 - 30, width: 60.0, height: 60.0)
        logo.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin]
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
        
        // animation
        rotationAnimation.toValue = Int(.pi * 2.0)
        rotationAnimation.duration = 2.0;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = Float.infinity;
        
        // generic
        backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityIndicator.stopAnimating), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityIndicator.startAnimating), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: public
    func show(inView: UIView) {
        DispatchQueue.main.async {
            ActivityIndicator.shared.frame = inView.bounds
            ActivityIndicator.shared.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            inView.addSubview(ActivityIndicator.shared)
            inView.bringSubview(toFront: ActivityIndicator.shared)
            ActivityIndicator.shared.startAnimating()
        }
    }
    
    func hide(inView: UIView) {
        if superview == inView {
            ActivityIndicator.shared.hide()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            ActivityIndicator.shared.stopAnimating()
            ActivityIndicator.shared.removeFromSuperview()
        }
    }
    
    func hideWithDelay() {
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            ActivityIndicator.shared.stopAnimating()
            ActivityIndicator.shared.removeFromSuperview()
        }
    }
    
    func hideWithDelay3Sec() {
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            ActivityIndicator.shared.stopAnimating()
            ActivityIndicator.shared.removeFromSuperview()
        }
    }


    
    // MARK: private
    private var spinner: UIImageView
    private var rotationAnimation: CABasicAnimation
    
    @objc private func startAnimating() {
        spinner.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    @objc private func stopAnimating() {
        spinner.layer.removeAllAnimations()
    }
}
