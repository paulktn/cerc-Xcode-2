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
        guard emailField.text != "" else {
            showAlertWith(title: "Error", message: "Please enter email", handler: nil)
            return
        }
        guard passwordField.text != "" else {
            showAlertWith(title: "Error", message: "Please enter password", handler: nil)
            return
        }
        
        ActivityIndicator.shared.show(inView: view)
        User.loginUser(withEmail: emailField.text!, password: passwordField.text!) { (error) in
            if error == nil {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.showAlertWith(title: "Error", message: error!, handler: nil)
            }
            defer {
                ActivityIndicator.shared.hideWithDelay()
            }
        }
    }
    
}
