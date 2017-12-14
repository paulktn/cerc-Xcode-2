//
//  ViewController+Common.swift
//  duminica
//
//  Created by Rostyk on 13.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation

extension UIViewController {
    func showAlertWith(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
}
