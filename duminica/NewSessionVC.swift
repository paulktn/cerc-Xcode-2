//
//  NewSessionVC.swift
//  duminica
//
//  Created by Chuchman Oleg on 04.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase

class NewSessionVC: UIViewController {

    @IBOutlet weak var emailField: UITextFieldX!
    @IBOutlet weak var passwordField: UITextFieldX!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": self.emailField.text!, "password": self.passwordField.text!]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
            }
        })
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
