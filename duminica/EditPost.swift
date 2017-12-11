//
//  EditPost.swift
//  GiveMain
//
//  Created by paul catana on 3/26/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import Photos

class EditPost: UIViewController, UIImagePickerControllerDelegate,  UICollectionViewDelegate, UICollectionViewDataSource,  UINavigationControllerDelegate {
    
    var passPostEdit: Post?
    
    
     let cellIdentifiers = ["miscellaneous", "clothing & accesories", "electronics", "furniture", "appliances", "household items", "sporting goods", "toys & games", "tools", "home improvement"]
    var currentUser: User?
    
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    @IBOutlet var imageFromCustCell3: CustomizableImageView!
    @IBOutlet var imageFromCustCell2: CustomizableImageView!
    @IBOutlet weak var titleFromCustCell: IQTextView!
    @IBOutlet weak var imageFromCustCell: CustomizableImageView!
    @IBOutlet weak var editCategory: CustomizableButton!
    @IBOutlet var PicturesView: UIView!
    @IBOutlet var camButton: UIButton!
    @IBOutlet weak var collectionCategories: UICollectionView!
    @IBOutlet var collectionViewPictures: UICollectionView!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var switch3: UISwitch!
    @IBOutlet var kakaa: UILabel!
    
    @IBOutlet var kakaa2: UILabel!
    
    @IBOutlet var kakaa3: UILabel!
    
    @IBOutlet var newDetails: IQTextView!
    
    @IBOutlet weak var detailsButton: CustomizableButton!
    
    
    @IBAction func presentDetails(_ sender: Any) {
        self.detailsButton.alpha = 0
        self.newDetails.alpha = 1
        self.titleFromCustCell.alpha = 0
        self.editCategory.alpha = 0
        
        
    }
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func chooseCategory(_ sender: Any) {
        self.newDetails.alpha = 0
        self.detailsButton.alpha = 0
        self.collectionCategories.alpha = 1
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.collectionCategories.alpha = 0
        self.newDetails.alpha = 0
        
         newDetails.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.detailsAlpha))
        
        titleFromCustCell.text! = (passPostEdit?.title)!
        editCategory.titleLabel!.text! = passPostEdit!.category.rawValue
       
        newDetails.text! = (passPostEdit?.details)!
//        kakaa.text! = (passPostEdit?.imageURLs.first ?? "")
//        kakaa2.text! = (passPostEdit!.imageURLs.count > 1 ? passPostEdit?.imageURLs[1].absoluteString ?? "" : "")
//        kakaa3.text! = (passPostEdit!.imageURLs.count > 2 ? passPostEdit?.imageURLs[2].absoluteString ?? "" : "")
//
//
//        self.imageFromCustCell.sd_setImage(with: URL(string: (passPostEdit?.postImageURL1)!))
//
//        if (passPostEdit?.postImageURL2)! != "no image" {
//       self.imageFromCustCell2.alpha = 1
//            self.imageFromCustCell2.sd_setImage(with: URL(string: (passPostEdit?.postImageURL2)!))
//        }
//
//
//        if (passPostEdit?.postImageURL3)! != "no image" {
//            self.imageFromCustCell3.alpha = 1
//            self.imageFromCustCell3.sd_setImage(with: URL(string: (passPostEdit?.postImageURL3)!))
//        }
        
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
        
        
              collectionViewPictures.delegate = self
        collectionViewPictures.dataSource = self
        collectionCategories.delegate = self
        collectionCategories.dataSource = self
        
        grabPhotos()
        
        
    }
    
    func detailsAlpha() {
        newDetails.alpha = 0
        editCategory.alpha = 1
        titleFromCustCell.alpha = 1
        detailsButton.alpha = 1
        detailsButton.setTitle("\(newDetails.text!)", for: .normal)
        view.endEditing(true)
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.newDetails.alpha = 0
    
    }
    
    
    
    
    @IBAction func deleteIt(_ sender: AnyObject) {
        
        deletePost()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func deletePost() {
        
      //  let childCategory = (passPostEdit?.postCategory)!
        let key = (passPostEdit?.id)!
        
       databaseRef.child("posts").child(key).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
    }
    
    
    
    
    func textView(_ textView: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textView.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= 200
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
                
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    
                    image, error in
                    
                    self.imageArray.append(image!)
                    
                })
            }
        } else {
            self.collectionViewPictures?.reloadData()
        }
    }
    
    
    @IBAction func photosIn(_ sender: UIButton) {
        
        switch sender {
        case button1:
       self.view.addSubview(PicturesView)
        PicturesView.center = view.center
       switch1.isOn = true;
            
        case button2:
            self.view.addSubview(PicturesView)
            PicturesView.center = view.center
            switch2.isOn = true;
            
            
        case button3:
            
            self.view.addSubview(PicturesView)
            PicturesView.center = view.center
            switch3.isOn = true;
            
        default:
            break
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCategories {
            return cellIdentifiers.count
        } else {
        return  imageArray.count
        
        }}
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewPictures {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
    let Cam = cell.viewWithTag(1) as! UIImageView
        
        Cam.image = imageArray[indexPath.row]
        
        //       cell.imageViewPhotoCell.image = UIImage(named: photos[indexPath.row])
        
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.item], for: indexPath)
            
        }}
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewPictures {
        if collectionView.cellForItem(at: indexPath) != nil {
            
            if self.switch1.isOn == true {
                
            self.imageFromCustCell.image = self.imageArray[indexPath.item]
                
                self.picturesOut()
        }
        else if switch2.isOn == true {
                
               self.imageFromCustCell2.image = self.imageArray[indexPath.item]
                self.picturesOut()
        } else if switch3.isOn == true {
                
               self.imageFromCustCell3.image = self.imageArray[indexPath.item]
                
                self.picturesOut()
                
           }  else {
 
               self.imageFromCustCell3.image = self.imageArray[indexPath.item]
                self.picturesOut()
                
                
            }}}else {
            
            self.editCategory.setTitle("\(self.cellIdentifiers[indexPath.item])", for: .normal)
         self.collectionCategories.alpha = 0
            self.detailsButton.alpha = 1
            self.newDetails.alpha = 0
        }}
    
    
    
    
    func picturesOut() {
        
        let postId = (passPostEdit?.id)!
        let image1 = imageFromCustCell.image
        let image2 = imageFromCustCell2.image
        let image3 = imageFromCustCell3.image
        let imageData1 = UIImageJPEGRepresentation(image1!, CGFloat(0.35))
        let imageData2 = UIImageJPEGRepresentation(image2!, CGFloat(0.35))
        let imageData3 = UIImageJPEGRepresentation(image3!, CGFloat(0.35))
        uploadImageToFirebase(postId: postId, imageData1: imageData1!, imageData2:imageData2!, imageData3: imageData3!, completion: { (url) in
            
            
            
        })
        
        
        
        
        
        PicturesView.removeFromSuperview()
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
    }
    
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
        
     if self.switch1.isOn == true {
            self.imageFromCustCell.image = image
        self.picturesOut()
    }
        else if switch2.isOn == true {
            self.imageFromCustCell2.image = image
        self.picturesOut()
        }else if switch3.isOn == true {
            self.imageFromCustCell3.image = image
        self.picturesOut()}
            else {
            self.imageFromCustCell.image = image
        self.picturesOut()}
        self.dismiss(animated: true, completion: nil)
    }



    
    @IBAction func outPictures(_ sender: AnyObject) {
        
        
        let postId = (passPostEdit?.id)!
        let image1 = imageFromCustCell.image
        let image2 = imageFromCustCell2.image
        let image3 = imageFromCustCell3.image
        let imageData1 = UIImageJPEGRepresentation(image1!, CGFloat(0.35))
        let imageData2 = UIImageJPEGRepresentation(image2!, CGFloat(0.35))
        let imageData3 = UIImageJPEGRepresentation(image3!, CGFloat(0.35))
        uploadImageToFirebase(postId: postId, imageData1: imageData1!, imageData2:imageData2!, imageData3: imageData3!, completion: { (url) in
        })
        
        
        
        
        
        PicturesView.removeFromSuperview()
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
    }
    
    func uploadImageToFirebase(postId: String, imageData1: Data, imageData2: Data, imageData3:Data, completion: @escaping (URL)->()){
        let postImagePath1 = "postImages/\(postId)image1.jpg"
        let postImageRef1 = storageRef.child(postImagePath1)
        let postImagePath2 = "postImages/\(postId)image2.jpg"
        let postImageRef2 = storageRef.child(postImagePath2)
        let postImagePath3 = "postImages/\(postId)image3.jpg"
        let postImageRef3 = storageRef.child(postImagePath3)
        let postImageMetadata = StorageMetadata()
        
        postImageMetadata.contentType = "image/jpeg"
        postImageRef1.putData(imageData1, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL1 = newPostImageMD?.downloadURL()
                {
                    self.kakaa.text! = "\(postImageURL1)"
                    completion(postImageURL1) }
                
                
                
            }}
        
        postImageRef2.putData(imageData2, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL2 = newPostImageMD?.downloadURL()  {
                    
                    if self.imageFromCustCell2.image == UIImage(named: "photoPlaceholder") {
                        self.kakaa2.text! = "no image"
                        
                    }else {
                        self.kakaa2.text! = "\(postImageURL2)"
                        completion(postImageURL2) }
                }
                
            }
        }
        postImageRef3.putData(imageData3, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL3 = newPostImageMD?.downloadURL() {
                    if self.imageFromCustCell3.image == UIImage(named: "photoPlaceholder") {
                        self.kakaa3.text! = "no image"
                        
                    }else {
                        self.kakaa3.text! = "\(postImageURL3)"
                        completion(postImageURL3) }
                    
                }
                
            }}
        
        ///////
    }
    
    
    
    
    
    @IBAction func saveAllChanges(_ sender: AnyObject) {
        
        
        let newDetailss = self.newDetails.text!
        let newTitle = titleFromCustCell.text!
      //  let childCategory = (passPostEdit?.postCategory)!
        let key = (passPostEdit?.id)!
        let newURL1 = kakaa.text!
        let newURL2 = kakaa2.text!
        let newURL3 = kakaa3.text!
        
        
        
        databaseRef.child("posts").child(key).updateChildValues(["postTitle":newTitle]) { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
    
    databaseRef.child("posts").child(key).updateChildValues(["postDetails":newDetailss]) { (error, ref) in
    if error != nil {
    print("error \(String(describing: error))")
    }
    }
    

databaseRef.child("posts").child(key).updateChildValues(["postImageURL1":newURL1]) { (error, ref) in
    if error != nil {
        print("error \(String(describing: error))")
    }
}


databaseRef.child("posts").child(key).updateChildValues(["postImageURL2":newURL2]) { (error, ref) in
    if error != nil {
        print("error \(String(describing: error))")
    }
}



databaseRef.child("posts").child(key).updateChildValues(["postImageURL3":newURL3]) { (error, ref) in
    if error != nil {
        print("error \(String(describing: error))")
    }
}
  dismiss(animated: true, completion: nil)
    
    }
















    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
        self.show(vc, sender: nil)
    }
    
    
    
    
    }
