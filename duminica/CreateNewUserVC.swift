//
//  CreateNewUserVC.swift
//  duminica
//
//  Created by Chuchman Oleg on 04.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase

class CreateNewUserVC: UIViewController {

    @IBOutlet weak var emailField: UITextFieldX!
    @IBOutlet weak var passwordField: UITextFieldX!
    @IBOutlet weak var nameField: UITextFieldX!
    @IBOutlet weak var addPhotoOutlet: UIButton!
    @IBOutlet weak var addPhotoImage: RoundedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera",
                                            style: .default,
                                            handler: { (action:UIAlertAction) in
                                                
                                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                                    let imagePickerController = UIImagePickerController()
                                                    imagePickerController.delegate = self
                                                    imagePickerController.sourceType = .camera
                                                    self.present(imagePickerController, animated: true, completion: nil)
                                                    
                                                }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePickerController = QBImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsMultipleSelection = true
                imagePickerController.mediaType = .image
                imagePickerController.maximumNumberOfSelection = 1
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error == nil {
                
                let values = ["name": self.nameField.text!, "email": self.emailField.text!, "password": self.passwordField.text!]
                Database.database().reference().child("ios_users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : self.emailField.text!, "password" : self.passwordField.text!]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    }
                })
                
            }
        })
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension CreateNewUserVC: QBImagePickerControllerDelegate {
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        guard let images = assets as? [PHAsset] else {
            return
        }
        
        let imgs = images.flatMap({$0.uiImage})
        self.addPhotoImage.image = imgs.first
        self.addPhotoOutlet.setTitle(nil, for: .normal)
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension CreateNewUserVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DispatchQueue.global().async {
            guard let image = ((info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage) else {return}
            
            DispatchQueue.main.async {
                
                self.addPhotoImage.image = image
                self.addPhotoOutlet.setTitle(nil, for: .normal)
                
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
