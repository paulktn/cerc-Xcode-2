//
//  OnboardingPresentationVC.swift
//  duminica
//
//  Created by paul catana on 9/14/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit


class OnboardingPresentationVC: UIViewController {
    @IBOutlet weak var view3: UIViewX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  findLocal()
        cercleIn()
           }

    func cercleIn() {
        UIView.animate(withDuration: 1, delay: 3, animations: {
            self.view3.frame.origin.x = -375
        }) { (true) in
             self.performSegue(withIdentifier: "toHome", sender: self)
        }
        
    }
}
