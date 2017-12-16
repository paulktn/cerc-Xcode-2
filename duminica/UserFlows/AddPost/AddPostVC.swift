//
//  Popoverfinal.swift
//  GiveMain
//
//  Created by paul catana on 4/9/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import Photos
import GeoFire

extension CLPlacemark {
    var compactAddress: String? {
        if name != nil {
            var result = ""
            if let city = locality {
                result += " \(city)"
            }
            if let state = administrativeArea {
                result += ", \(state)"
            }
            return result
        }
        return nil
    }
}



class AddPostVC: UIViewController, UICollectionViewDataSource, CLLocationManagerDelegate, UICollectionViewDelegate {
    
    //  MARK: IBOutlets
    
    @IBOutlet weak var savingBackground: UIView!
    @IBOutlet weak var locationViewBand: UIView!
    @IBOutlet weak var keyword: CustomizableButton!
    @IBOutlet weak var keywordCollection: UICollectionView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    @IBOutlet weak var details: IQTextView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var savingPost: UILabel!
    @IBOutlet weak var postButton: UIButtonX!
    @IBOutlet weak var locationButton: CustomizableButton!
    @IBOutlet weak var enterZipcode: IQTextView!
    @IBOutlet weak var chooseCategoryButton: CustomizableButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var presentDetailView: CustomizableButton!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var detailsIcon: UIImageView!
    @IBOutlet weak var categoriesIcon: UIImageView!
    @IBOutlet weak var hashtagIcon: UIImageView!
    @IBOutlet weak var errorLabelCategory: CustomLabel!
    @IBOutlet weak var errorLabelLocation: CustomLabel!
    
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    @IBOutlet var chooseCategoryLabel: UILabel!
    @IBOutlet var chooseKeywordLabel: UILabel!
    @IBOutlet var itemDetailsLabel: UILabel!
    
    //  MARK: - Collections Height
    
    @IBOutlet weak var categoryCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var keywordCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    
    var imageArray = [UIImage]()
    
    var coordinatesGhost: String!
    var thumbImage: UIImage!
    var thumbLink: String!
    
    var poza1: String! = "" {
        didSet{
            if poza1 != "" {
                self.savingBackground.alpha = 0
                self.postButton.alpha = 1
            }
        }
    }
    
    var poza2: String! = ""{
        didSet{
            if poza2 != "" {
                self.savingBackground.alpha = 0
                self.postButton.alpha = 1
            }
        }
    }
    
    var poza3: String! = ""{
        didSet{
            if poza3 != "" {
                
                self.savingBackground.alpha = 0
                self.postButton.alpha = 1
                
            }
        }
    }
    
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    
    var clothingWords = ["blouse", "boots", "coat", "dress", "handbag", "jacket", "jeans", "pijamas","pants", "raincoat", "shirt", "suit", "shoes", "skirt", "slacks", "shorts", "snowsuit", "sweater", "tuxedo", "women's accesories", "other"]
    var furnitureWords = ["bed(single)", "bed(f/q/k)", "folding bed", "bedroom set", "chair", "chest", "china cabinet", "clothes closet", "coffee table", "crib", "desk", "dining room set", "dresser", "end table", "hi riser", "kitchen cabinet", "mattress", "rugs", "secretary", "sofa", "sleeper sofa", "trunk", "wardrobe", "other"]
    var householdWords = ["bakeware", "bedspread/quilt", "chair/sofa cover", "coffeemaker", "curtains", "drapes", "fireplace set", "floor lamp", "glass/cup", "griddle", "kitchen utensils", "lamp", "mixer/blender", "picture/painting", "pillow", "pot/pan", "sheets", "throw rug", "towels", "vacuum", "other"]
    var electronicsWords = ["cell phone", "computer monitor", "computer desktop", "copier", "dvd", "dvd player", "radio/cd player", "printer", "tv", "other"]
    var appliancesWords = ["air conditioner", "dryer", "electric stove", "gas stove", "microwave", "refrigerator", "tv", "washing machine", "other"]
    var sportingWords = ["bicycle", "fishing rod", "ice/roller skates", "tennis rackets", "toboggans"]
    var toysWords = ["action figures", "cars and remote controlled", "construction toys", "doll", "educational toys", "electronics toys", "plush toys", "puzzle", "wooden toys"]
    var homeimprovementWords = ["measuring tool", "hammer", "electrical drill", "cutting tool", "hand saw", "electrical saw", "construction materials", "screwdriver", "others"]
    var miscellaneousWords = ["miscellaneous"]
    let cellIdentifiers = ["appliances", "clothing & accesories", "electronics", "furniture", "home improvement", "household items", "sporting goods", "toys & games", "miscellaneous"]
    
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        return Storage.storage().reference()
    }
    
    lazy var geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    
    private var currentLocation: CLLocationCoordinate2D!
    
    var canSendLocation = true
    var postIdLocation: String! = ""
    var pozaurl: String! = ""
    
    private enum OpenedOption {
        case location
        case category
        case keywords
        case details
        case none
    }
    
    private var currentOption: OpenedOption = .none
    
    private func selectOption(_ newOption: OpenedOption) {
        
        defer {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        closeAllCollections()
        
        guard currentOption != newOption else {
            currentOption = .none
            return
        }
        
        switch newOption {
        case .location:
            break
        case .category:
            categoryCollectionHeight.constant = 40
            collectionCategories.alpha = 1
        case .keywords:
            keywordCollectionHeight.constant = 40
            keywordCollection.alpha = 1
        case .details:
            detailsViewHeight.constant = 80
            details.alpha = 1
        case .none:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        currentOption = newOption
    }
    
    func closeAllCollections() {
        categoryCollectionHeight.constant = 0
        keywordCollectionHeight.constant = 0
        detailsViewHeight.constant = 0
        collectionCategories.alpha = 0
        keywordCollection.alpha = 0
        details.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savingBackground.alpha = 0
        errorLabelCategory.isHidden = true
        errorLabel.isHidden = true
        errorLabelLocation.isHidden = true
        locationViewBand.alpha = 0
        keywordCollection.alpha = 0
        geoFireRef = Database.database().reference().child("postLocations")
        geoFire = GeoFire(firebaseRef: geoFireRef)
        keywordCollection.delegate = self
        keywordCollection.dataSource = self
        collectionCategories.dataSource = self
        collectionCategories.delegate = self
        collectionCategories.alpha = 0
        details.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.detailsAlpha))
        enterZipcode.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.per))
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        //grabPhotos()
        
        closeAllCollections()
        
        self.locationManager.delegate = self
    }
    
    func detailsAlpha() {
        itemDetailsLabel.text = details.text
        view.endEditing(true)
    }
    
    func doneClicked() {
        itemDetailsLabel.text = details.text
        view.endEditing(true)
    }
    
    
    // MARK: - CATEGORIES PICKER
    
    @IBAction func enterDetails(_ sender: Any) {
        selectOption(.details)
    }
    
    @IBAction func presentKeywordCollection(_ sender: AnyObject) {
        
        keywordCollection.reloadData()
        selectOption(.keywords)
    }
    @IBAction func presentCategories(_ sender: Any) {
        selectOption(.category)
    }
    @IBAction func presentLocationView(_ sender: AnyObject) {
        
        locationViewBand.alpha = 1
        locationButton.alpha = 0
        errorLabelLocation.isHidden = true
        
    }
    
    // MARK: - location
    
    func per() {
        guard let city = enterZipcode.text else { return }
        
        // Create Address String
        let address = "\(city)"
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }}
    func geocodeWhat(_ sender: UIButton) {
        
        
        guard let city = enterZipcode.text else { return }
        
        // Create Address String
        let address = "\(city)"
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            self.processResponse(withPlacemarks: placemarks, error: error)
        }}
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
            
        } else {
            if let placemarks = placemarks,
                let placemark = placemarks.first {
                
                if let lat = placemark.location?.coordinate.latitude,
                    let lon = placemark.location?.coordinate.longitude {
                    print("\(String(describing: lat))")
                    print("\(String(describing: lon))")
                    
                    currentLocation = CLLocationCoordinate2D(latitude: lat,
                                                             longitude: lon)
                    
                    let coordinates = ("\(String(describing: lat))") + ":" + ("\(String(describing: lon))")
                    print(coordinates)
                    postIdLocation = coordinates
                }
                view.endEditing(true)
                locationButton.setTitle(placemark.compactAddress, for: .normal)
                
                locationViewBand.alpha = 0
                chooseCategoryButton.alpha = 1
                keyword.alpha = 1
                
                locationButton.alpha = 1
                postButton.alpha = 1
            }
        }
    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    
    @IBAction func useCurentLocation(_ sender: AnyObject)
    {
        
        self.canSendLocation = true
        
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationButton.alpha = 1
        locationViewBand.alpha = 0
    }
    
    private func xxxprocessResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            locationButton.setTitle("Unable to find address", for: .normal)
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                
                locationButton.setTitle(placemark.compactAddress, for: .normal)
                
                locationViewBand.alpha = 0
                chooseCategoryButton.alpha = 1
                keyword.alpha = 1
                postButton.alpha = 1
            } else {
                locationButton.setTitle("No matching location", for: .normal)
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        currentLocation = userLocation.coordinate
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let coordinates = String(userLocation.coordinate.latitude) + ":" + String(describing: userLocation.coordinate.longitude)
        print(coordinates)
        postIdLocation = coordinates
        print(postIdLocation)
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            // Process Response
            self.xxxprocessResponse(withPlacemarks: placemarks, error: error)
            
            self.stopUpdatingLocation() }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
        }
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == self.collectionCategories  {
            return cellIdentifiers.count
        }  else  if collectionView == self.keywordCollection {
            switch self.chooseCategoryLabel.text! {
                
            case "choose category":
                return 1
            case "appliances":
                return appliancesWords.count
            case "clothing & accesories":
                return clothingWords.count
            case "electronics":
                return electronicsWords.count
            case "furniture":
                return furnitureWords.count
            case "household items":
                return householdWords.count
            case "sporting goods":
                return sportingWords.count
            case "toys & games":
                return toysWords.count
            case "home improvement":
                return homeimprovementWords.count
            case "miscellaneous":
                return miscellaneousWords.count
                
            default:
                return 1
            }
        }
        
        if collectionView === imagesCollection {
            return imageArray.count + 1
        }
            
        else   {
            return imageArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionCategories {
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.item], for: indexPath)
        } else if collectionView === imagesCollection {
            if indexPath.item == imageArray.count {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotoCell", for: indexPath)
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
                cell.cellImageView.image = imageArray[indexPath.item]
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keywordCell", for: indexPath as IndexPath) as! keywordCell
            
            switch self.chooseCategoryLabel.text ?? "" {
                
            case "appliances":
                cell.keywords.text! = self.appliancesWords[indexPath.item]
                return cell;
                
                
            case "clothing & accesories":
                cell.keywords.text! = self.clothingWords[indexPath.item]
                return cell;
                
            case "electronics":
                cell.keywords.text! = self.electronicsWords[indexPath.item]
                return cell;
                
            case "furniture":
                cell.keywords.text! = self.furnitureWords[indexPath.row]
                return cell;
                
            case "household items":
                cell.keywords.text! = self.householdWords[indexPath.item]
                return cell;
                
            case "sporting goods":
                cell.keywords.text! = self.sportingWords[indexPath.item]
                return cell;
            case "toys & games":
                
                cell.keywords.text! = self.toysWords[indexPath.item]
                return cell;
                
            case "home improvement":
                cell.keywords.text! = self.homeimprovementWords[indexPath.item]
                return cell
                
            case "miscellaneous":
                cell.keywords.text! = self.miscellaneousWords[indexPath.item]
                return cell;
                
            default:
                cell.keywords.text! = "please first choose a category"
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView === imagesCollection {
            if indexPath.item == imageArray.count {
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
            } else {
                let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "Delete",
                                                    style: .destructive,
                                                    handler: { (action:UIAlertAction) in
                                                        self.imageArray.remove(at: indexPath.item)
                                                        collectionView.deleteItems(at: [indexPath])
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
            
        else if collectionView == self.keywordCollection {
            
            switch self.chooseCategoryLabel.text! {
                
            case "choose category":
                chooseKeywordLabel.text = "first choose category"
            case "appliances":
                chooseKeywordLabel.text = "\(self.appliancesWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "clothing & accesories":
                chooseKeywordLabel.text = "\(self.clothingWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "electronics":
                chooseKeywordLabel.text = "\(self.electronicsWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "furniture":
                chooseKeywordLabel.text = "\(self.furnitureWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "household items":
                chooseKeywordLabel.text = "\(self.householdWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "sporting goods":
                chooseKeywordLabel.text = "\(self.sportingWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "toys & games":
                chooseKeywordLabel.text = "\(self.toysWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "home improvement":
                chooseKeywordLabel.text = "\(self.homeimprovementWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "miscellaneous":
                chooseKeywordLabel.text = "\(self.miscellaneousWords[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
                
            default:
                chooseKeywordLabel.text = "\(self.cellIdentifiers[indexPath.item])"
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
                
            }
            
            selectOption(.keywords)
        }
            
        else if collectionView == self.collectionCategories {
            chooseCategoryLabel.text = "\(self.cellIdentifiers[indexPath.item])"
            self.collectionCategories.alpha = 0
            self.presentDetailView.alpha = 1
            self.detailsIcon.alpha = 1
            keyword.alpha = 1
            hashtagIcon.alpha = 1
            errorLabel.text = ""
            self.keywordCollection.reloadData()
            selectOption(.category)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.pushTomainView()
    }
    
    func pushTomainView() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
//        self.show(vc, sender: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func savePost(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        // check save
        
        if self.chooseKeywordLabel.text == "choose a keyword" {
            errorLabelCategory.text = "!"
            
            errorLabelCategory.isHidden = false
        }
        
        // check category
        
        if self.chooseCategoryLabel.text == "choose category" {
            errorLabel.text = "!"
            errorLabel.isHidden = false
        } else {
            print("category ok")
        }
        
        // check location
        
        if self.locationButton.titleLabel!.text! == "Location" {
            errorLabelLocation.text = "!"
            errorLabelLocation.isHidden = false
        }
        if chooseKeywordLabel.text != "choose a keyword" &&  self.chooseCategoryLabel.text != "choose category"  && self.locationButton.titleLabel?.text != "Location" && !imageArray.isEmpty {
            
            let allPosts = "allPosts"
            let postTitle = chooseKeywordLabel.text
            let postDetails = details.text
            let postCategory = chooseCategoryLabel.text
            let postId = NSUUID().uuidString
            let postDate = NSDate().timeIntervalSince1970 as NSNumber
            let city =  locationButton.titleLabel!.text!
            
            let iosPostRef = databaseRef.child(Session.FirebasePath.ALL_POSTS_KEY).child(postId)
            iosPostRef.setValue(["location_title": city,
                                 "longitude": currentLocation.longitude,
                                 "latitude": currentLocation.latitude,
                                 "category": postCategory ?? "",
                                 "date": postDate,
                                 "details": postDetails ?? "",
                                 "title": self.postTitle.text ?? "",
                                 "owner_id": AppDelegate.session.user?.id ?? "",
                                 "keywords": chooseKeywordLabel.text ?? ""])
            
            
            
            func delay(delay: Double, closure: @escaping () -> ()) {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    closure()
                }
            }
            
            // MARK: - Images Uploading
            
            let postImageMetadata = StorageMetadata()
            postImageMetadata.contentType = "image/jpeg"
            
            DispatchQueue.global(qos: .background).async {
                
                var imagesData = self.imageArray.flatMap({$0.jpeg(.medium)})
                
                for i in 0..<imagesData.count {
                    let postImagePath = "postImages/\(postId)image\(i+1).jpg"
                    let postImageRef = self.storageRef.child(postImagePath)
                    postImageRef.putData(imagesData[i], metadata: postImageMetadata) { (newPostImageMD, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            if let postImageURL = newPostImageMD?.downloadURL()
                            {
                                let iosPostRef = self.databaseRef.child(Session.FirebasePath.ALL_POSTS_KEY).child(postId)
                                iosPostRef.child("images").childByAutoId().setValue(postImageURL.absoluteString)
                            }
                        }
                    }
                }
                
                let postThumbPath = "postImages/\(postId)postThumb.jpg"
                let postThumbRef = self.storageRef.child(postThumbPath)
                
                if let postThumb = self.imageArray.first?.resized(withPercentage: 0.5)?.jpeg(.low) {
                    
                    postThumbRef.putData(postThumb, metadata: postImageMetadata) { (newPostImageMD, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            if let postThumbURL = newPostImageMD?.downloadURL()
                            {
                                let iosPostRef = self.databaseRef.child(Session.FirebasePath.ALL_POSTS_KEY).child(postId)
                                iosPostRef.child("logo_url").setValue(postThumbURL.absoluteString)
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func editAlertGone() {
        errorLabel.isHidden = true
        view.endEditing(true)
    }
    
    fileprivate func addImageToCollection(_ image: UIImage) {
        imageArray.append(image)
        imagesCollection.reloadData()
    }
}

extension AddPostVC:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === self.imagesCollection {
            return CGSize(width: 139, height: 139)
        }
        
        // Will be fixed later
        
//        } else if collectionView === self.collectionCategories {
//            let category =  cellIdentifiers[indexPath.item]
//            let width = UILabel.widthFor(text: category, font: UIFont.systemFont(ofSize: 17), height: 35)
//            return CGSize(width: width + 8, height: 35)
//        } else if collectionView === self.keywordCollection {
//
//            var text = ""
//
//            switch self.chooseCategoryLabel.text! {
//
//        case "     choose category":
//            text = "first choose category"
//        case "appliances":
//            text = "\(self.appliancesWords[indexPath.item])"
//        case "clothing & accesories":
//            text = "\(self.clothingWords[indexPath.item])"
//        case "electronics":
//            text = "\(self.electronicsWords[indexPath.item])"
//        case "furniture":
//            text = "\(self.furnitureWords[indexPath.item])"
//        case "household items":
//            text = "\(self.householdWords[indexPath.item])"
//        case "sporting goods":
//            text = "\(self.sportingWords[indexPath.item])"
//        case "toys & games":
//            text = "\(self.toysWords[indexPath.item])"
//        case "home improvement":
//            text = "\(self.homeimprovementWords[indexPath.item])"
//        case "miscellaneous":
//            text = "\(self.miscellaneousWords[indexPath.item])"
//
//        default:
//            text = "\(self.cellIdentifiers[indexPath.item])"
//            }
//
//            let width = UILabel.widthFor(text: text, font: UIFont.systemFont(ofSize: 17), height: 35)
//            return CGSize(width: width + 8, height: 35)
//        }
        
        return CGSize(width: 150, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

extension AddPostVC: QBImagePickerControllerDelegate {
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        guard let images = assets as? [PHAsset] else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let images = images.flatMap({$0.uiImage})
            DispatchQueue.main.async {
                images.forEach({self.addImageToCollection($0)})
            }
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension AddPostVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        DispatchQueue.global().async {
            guard let image = ((info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage) else {return}
            
            DispatchQueue.main.async {
                
                self.addImageToCollection(image)
                
                
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
