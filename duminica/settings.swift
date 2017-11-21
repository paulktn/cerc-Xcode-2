//
//  settings.swift
//  Pods
//
//  Created by paul catana on 9/4/17.
//
//

import Foundation
import UIKit
import Firebase
import Photos
import SDWebImage


class settingsPage: UIViewController,  UIImagePickerControllerDelegate,  UICollectionViewDelegate, UICollectionViewDataSource,  UINavigationControllerDelegate {
    
    
    @IBOutlet var picturesView: UIViewX3!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var emailAdresButton: UIButton!

    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var collectionPictures: UICollectionView!
   
    @IBOutlet weak var nameField: IQTextView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var picSwitch: UISwitch!
    
    @IBOutlet weak var switchEmailReminders: UISwitch!
    
    @IBOutlet weak var switchEmailMessages: UISwitch!
    
    @IBOutlet weak var switchPushMessages: UISwitch!
    
    @IBOutlet weak var switchPushItems: UISwitch!
    
    @IBOutlet weak var switchSMS: UISwitch!
    
    
    
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    var link: String!
    var nameLink: String!
    var poza: String!
    
    @IBAction func picChange(_ sender: Any) {
        if self.picSwitch.isOn == true {
            self.profilePic.alpha = 1
        } else {
            self.profilePic.alpha = 0
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getEmail()
       getURL()
       customization()
        grabPhotos()
        
        collectionPictures.delegate = self
        collectionPictures.dataSource = self
        
        nameField.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.changeNameAction))
        nameField.alpha = 0
    }
    func doneClicked() {
        view.endEditing(true)
      
    }
    
    @IBAction func emailReminders(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser?.uid {
            switch self.switchEmailReminders.isOn {
            case false :
                databaseRef.child("users").child(currentUser).child("options").child("emailReminders").setValue("no"){ (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    }}
            default:
                databaseRef.child("users").child(currentUser).child("options").child("emailReminders").setValue("yes"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            }}}
    
    
    @IBAction func emailMessages(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser?.uid {
            switch self.switchEmailMessages.isOn {
            case false :
                databaseRef.child("users").child(currentUser).child("options").child("emailMessages").setValue("no"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            default:
                databaseRef.child("users").child(currentUser).child("options").child("emailMessages").setValue("yes"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            }}
    }
    
    
    @IBAction func PushNotifications(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser?.uid {
            switch self.switchPushMessages.isOn {
            case false :
                databaseRef.child("users").child(currentUser).child("options").child("pushMessages").setValue("no"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            default:
                databaseRef.child("users").child(currentUser).child("options").child("pushMessages").setValue("yes"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            }}
    }
    
    
    @IBAction func PushNewItems(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser?.uid {
            switch self.switchPushItems.isOn {
            case false :
                databaseRef.child("users").child(currentUser).child("options").child("pushNewItems").setValue("no"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            default:
                databaseRef.child("users").child(currentUser).child("options").child("pushNewItems").setValue("yes"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            }}
    }
    
    @IBAction func smsAction(_ sender: Any) {
        
        if let currentUser = Auth.auth().currentUser?.uid {
            switch self.switchSMS.isOn {
            case false :
                databaseRef.child("users").child(currentUser).child("options").child("SMS").setValue("no"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            default:
                databaseRef.child("users").child(currentUser).child("options").child("SMS").setValue("yes"){ (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    }}
            }}
    }
    
    
    
    func getURL() {
        let currentUser = Auth.auth().currentUser!.uid
        databaseRef.child("users").child(currentUser).child("credentials").child("id").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.profilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                print(snapshot.value!)  }   else
                
            { if let id = Auth.auth().currentUser?.uid {
                User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                    let removal: [Character] = [".", "#", "$", "@"]
                    
                    let unfilteredCharacters = ("\(user.email)").characters
                    
                    let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                    
                    let filtered = String(filteredCharacters)
                    
                    weakSelf?.link = ("\(user.email)")
                    self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").observe(.value, with: { (snapshot) in
                        if snapshot.exists(){
                            self.profilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
                        }})})}}})}
    
    func customization() {
        if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(currentUser).child("credentials").child("name").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.nameButton.setTitle("\(snapshot.value!)", for: .normal)
                   // print(snapshot.value!)
                }})}
        else {
            takeToLogin()
        }}
    
    
    @IBAction func back(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func presentPicView(_ sender: Any) {
        self.view.addSubview(picturesView)
        self.picturesView.center = self.view.center
    }
       
    var imageArray = [UIImage]()
    
    func grabPhotos() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = .original
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 50
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            
            for i in 0..<fetchResult.count {
                
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    
                    image, error in
                    
                    self.imageArray.append(image!)
                    
                })
                
            }
            
            
        } else {
            
            self.collectionPictures?.reloadData()}}
    
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.profilePic.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return  imageArray.count
            }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
            let Cam = cell.viewWithTag(1) as! UIImageView
            
            Cam.image = imageArray[indexPath.row]
            
            //       cell.imageViewPhotoCell.image = UIImage(named: photos[indexPath.row])
            
            return cell
       }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.cellForItem(at: indexPath) != nil {
            
            self.profilePic.image = self.imageArray[indexPath.item]
            self.outPictures()
            
        }}
    

    func outPictures() {
        
        let image1 = profilePic.image
        let imageData1 = UIImageJPEGRepresentation(image1!, CGFloat(0.35))
        uploadImageToFirebase(imageData1: imageData1!, completion: { (url) in
        })
      
        self.picturesView.removeFromSuperview()
        self.button1.setTitle("", for: .normal)
           }
    
    func uploadImageToFirebase(imageData1: Data, completion: @escaping (URL)->()){
        let postImagePath1 = "profileImages/\(String(describing: self.emailAdresButton.titleLabel?.text!))/image1.jpg"
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
                    let unfilteredCharacters = String(describing: self.emailAdresButton.titleLabel?.text!).characters
                    let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                    let filtered = String(filteredCharacters)
                    self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").setValue(self.poza)
                    print(self.poza)
                    self.button1.setTitle("", for: .normal)
                    completion(postImageURL1)
                }}}}




    
    func takeToLogin() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginActually
        self.show(loginVC, sender: nil)
    }
    
    func getEmail() {
        if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(currentUser).child("credentials").child("email").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.emailAdresButton.setTitle("\(snapshot.value!)", for: .normal)
                    // print(snapshot.value!)
                }})}}
    
    @IBAction func changeEmail(_ sender: Any) {
                 }
    
    @IBAction func changeName(_ sender: Any) {
          self.nameField.alpha = 1
        self.nameButton.alpha = 0

    }
           func changeNameAction(){
          if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(currentUser).child("credentials").child("name").setValue("\(nameField.text!)"){ (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                }}}
    self.nameField.alpha = 0
        self.nameButton.setTitle("\(self.nameField.text!)", for: .normal)
    self.nameButton.alpha = 1
       view.endEditing(true)     
    }
}
