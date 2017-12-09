//
//  LoginVC.swift
//  duminica
//
//  Created by Chuchman Oleg on 04.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginWithEmailPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    
    @IBAction func loginWithFBPressed(_ sender: Any) {
    }
    
    @IBAction func noAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToCreateUser", sender: nil)
    }
    
    @IBAction func homePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
