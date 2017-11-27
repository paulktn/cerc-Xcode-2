//
//  InformationVC.swift
//  duminica
//
//  Created by paul catana on 9/6/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit

class InformationVC: UIViewController {
    
    @IBOutlet var aboutUsView: UIView!
    @IBOutlet var privacyPolicyView: UIView!
    
    @IBOutlet var termsOfUse: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeView
        self.show(vc, sender: nil)
    }
    
    @IBAction func presentAboutUsView(_ sender: Any) {
        self.view.addSubview(aboutUsView)
    }
    @IBAction func dismissAboutUs(_ sender: Any) {
        self.aboutUsView.removeFromSuperview()
    }
    
    @IBAction func dismissTermsOfUse(_ sender: Any) { self.termsOfUse.removeFromSuperview()
    }
    
    @IBAction func presentPrivacyPolicyView(_ sender: Any) {
        self.view.addSubview(privacyPolicyView)
        }
    
    @IBAction func dismissPrivacyPolicyView(_ sender: Any) {
        self.privacyPolicyView.removeFromSuperview()
    }
    
    @IBAction func presentTermsOfUse(_ sender: Any) { self.view.addSubview(termsOfUse)
    }
    
    
    @IBAction func back(_ sender: Any) {
      self.pushTomainView()
    }
    
    @IBAction func stop(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
