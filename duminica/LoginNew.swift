//
//  LoginNew.swift
//  GiveMain
//
//  Created by paul catana on 7/15/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase
import Photos





class LoginActually: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
 
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var profilePicView: UIView!
    @IBOutlet weak var passwordField: CustomizableTextfield!
    @IBOutlet weak var nameField: CustomizableTextfield!
    @IBOutlet weak var emailAdres: CustomizableTextfield!
    @IBOutlet weak var createAccButton: CustomizableButton!
    @IBOutlet weak var customFBButton: CustomizableButton!
    @IBOutlet weak var homeButton: CustomizableButton!
    @IBOutlet weak var loginWithEmail: UIButton!
    @IBOutlet weak var invisibleForFB: UIButton!
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    
    
    var loginWithEmailCenter: CGPoint!
    var facebookLoginCenter: CGPoint!
    var passwordFieldCenter: CGPoint!
    var emailAdresCenter: CGPoint!
    var createAccButtonCenter: CGPoint!
    var loginCenter: CGPoint!
    var poza: String!
    var pozaFacebook: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        nameField.delegate = self
        passwordField.delegate = self
        emailAdres.delegate = self
        grabPhotos()
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        check()
     
        
       
        
        passwordField.alpha = 0
        emailAdres.alpha = 0
        createAccButton.alpha = 0
        createAccButton.alpha = 0
        nameField.alpha = 0
        button1.alpha = 0
        profilePic.alpha = 0
       
        passwordFieldCenter = passwordField.center
        emailAdresCenter = emailAdres.center
        createAccButtonCenter = createAccButton.center
        
        passwordField.center = loginWithEmail.center
        emailAdres.center = loginWithEmail.center
        createAccButton.center = loginWithEmail.center
        
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.showProfilePic()
        return true
    }
    
    func showProfilePic() {
        
          
            if emailAdres.text! != "" {
            self.button1.alpha = 1
            self.profilePic.alpha = 1
                view.endEditing(true) }
        }
    
    var imageArray = [UIImage]()
    
    func grabPhotos() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 30
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            
            for i in 0..<fetchResult.count {
                
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    
                    image, error in
                    
                    self.imageArray.append(image!)
                    
                })
                
            }
            
            
        } else {
            
            self.collectionView?.reloadData()}}
    
    
    
    
    
    
    @IBAction func photosIn(_ sender: UIButton) {
        
       
            self.view.addSubview(self.profilePicView)
            self.profilePicView.center = view.center
        
           }
    
    
    
    
    
    
    
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
        let Cam = cell.viewWithTag(1) as! UIImageView
        
        Cam.image = imageArray[indexPath.row]
        
        //       cell.imageViewPhotoCell.image = UIImage(named: photos[indexPath.row])
        
        return cell }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.cellForItem(at: indexPath) != nil {
            
        self.profilePic.image = self.imageArray[indexPath.item]
            
            
        }}
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //   let itemsPerRow:CGFloat = 2.4
        //   let hardCodedPadding:CGFloat = 0
        let itemWidth = 129
        return CGSize(width: itemWidth, height: 129)
        }
        
        
        
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
      self.profilePic.image = image
      self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func outPictures(_ sender: AnyObject) {
        let image1 = profilePic.image
        let imageData1 = UIImageJPEGRepresentation(image1!, CGFloat(0.35))
        uploadImageToFirebase(imageData1: imageData1!, completion: { (url) in
            })
        self.profilePicView.removeFromSuperview()
        self.button1.setTitle("", for: .normal)
        
        self.loginWithEmail.isEnabled = true
        
    }
    
    func uploadImageToFirebase(imageData1: Data, completion: @escaping (URL)->()){
        let postImagePath1 = "profileImages/\(self.emailAdres.text!)/image1.jpg"
        let postImageRef1 = storageRef.child(postImagePath1)
        let postImageMetadata = StorageMetadata()
        postImageMetadata.contentType = "image/jpeg"
        
        postImageRef1.putData(imageData1, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL1 = newPostImageMD?.downloadURL()
                {
                    self.poza = "\(postImageURL1)"
                    let removal: [Character] = [".", "#", "$", "@"]
                        let unfilteredCharacters = self.emailAdres.text!
                        let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                        let filtered = String(filteredCharacters)
                        self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").setValue(self.poza)
                    print(self.poza)
                    self.button1.setTitle("", for: .normal)
                    completion(postImageURL1)
                }}}}
    
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", "err  ")
                return
            }
            self.showEmailAddress()
            }}
    
    
    
    
    
    
    
    @IBAction func loginwithemailclicked(_ sender: Any) {
        if (loginWithEmail.titleLabel!.text! != "Login") {
        passwordField.alpha = 1
        emailAdres.alpha = 1
        createAccButton.alpha = 1
        loginWithEmail.setTitle("Login", for: .normal)
        UIView.animate(withDuration: 0.4,  animations:{
                       self.passwordField.center = self.passwordFieldCenter
            self.emailAdres.center = self.emailAdresCenter
            self.createAccButton.center = self.createAccButtonCenter
            self.customFBButton.center = self.invisibleForFB.center
            self.customFBButton.alpha = 0
        })} else if (loginWithEmail.titleLabel!.text! == "create account"){
            self.kj()
        } else {
            if emailAdres.text! != "" && passwordField.text! != ""{
                Auth.auth().signIn(withEmail: emailAdres.text!, password: passwordField.text!, completion: { (user, error) in
                    if error == nil {
                        let userInfo = ["email": self.emailAdres.text!, "password": self.passwordField.text!]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                  
                        print("nu merge")
                    
                    }})}}}
    
   
    
    
    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard (accessToken?.tokenString) != nil else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            let uid = user?.uid //the firebase uid
            let thisUserRef = self.databaseRef.child(uid!)
            thisUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                      print("Successfully logged in with our user: ", user ?? "")
            self.dismiss(animated: true, completion: nil)
                } else {
                     FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            
            guard let fbUser = Auth.auth().currentUser?.uid  else { return }
            
            let facebuser = "\(fbUser)"
        
            let values = result ?? ""
            Database.database().reference().child("users").child(facebuser).child("credentials").updateChildValues(values as! [AnyHashable : Any], withCompletionBlock: { (errr, _) in
                if errr == nil {
                    let userInfo = ["email" : result ?? "email"]
                    UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    
                    
                    
                    self.dismiss(animated: true, completion: nil)                    
                    }})
            
            print(result ?? "")
            print(result ?? "name")
            
                    }}})})}
    
    func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }}    ////// email  portion
    
    func kj () {
        User.registerUser(withName: nameField.text!, email: emailAdres.text!, password: passwordField.text!, completion: {_ in 
            self.login()
            self.delay(delay: 2){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
                self.show(vc, sender: nil)
            }
       
        })
    }
    
    func createRegister() {
        func registerUser(withName: String, email: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
            
            Auth.auth().createUser(withEmail: emailAdres.text!, password: passwordField.text!, completion: { (user, error) in
                if error == nil {
                    
                    let values = ["name": withName, "email": email, "password": password]
                    Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                        if errr == nil {
                            let userInfo = ["email" : email, "password" : password]
                            UserDefaults.standard.set(userInfo, forKey: "userInformation")
                            completion(true)
                            
                        }})}
else {
                    completion(false)
                    print("nope")
                }})}}
    
func login(){
        func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
            Auth.auth().signIn(withEmail: emailAdres.text!, password: passwordField.text!, completion: { (user, error) in
                if error == nil {
                    let userInfo = ["email": withEmail, "password": password]
                    UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    completion(true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    completion(false)
                    print("nu merge")
                }
            })
        }}
    
    
        
        func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "userInformation")
                completion(true)
            } catch _ {
                completion(false)
            }}

    
    
    func check() {
        if (emailAdres.text?.isEmpty == false){
            databaseRef.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild(self.emailAdres.text!){
                    
                    print("true rooms exist")
                    
                }else{
                    
                    print("false room doesn't exist")
                }
            })
        }
    }
    
    @IBAction func noAccount(_ sender: Any) {
        
            passwordField.alpha = 1
            emailAdres.alpha = 1
            self.nameField.alpha = 1
        
            self.button1.alpha = 0
            self.profilePic.alpha = 0
           // createAccButton.setTitle("Create account", for: .normal)
            createAccButton.alpha = 0 
            self.loginWithEmail.setTitle("create account", for: .normal)
        self.loginWithEmail.isEnabled = false
    }
    
    
    @IBAction func CancelLogin(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
}
