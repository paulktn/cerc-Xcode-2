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
    }}

class AddPostVC: UIViewController, UIImagePickerControllerDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, CLLocationManagerDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var savingBackground: UIView!
    @IBOutlet weak var locationViewBand: UIView!
    @IBOutlet weak var keyword: CustomizableButton!
    @IBOutlet weak var keywordCollection: UICollectionView!
    @IBOutlet weak var collectionCategories: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var details: IQTextView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var savingPost: UILabel!
    @IBOutlet var PicturesView: UIView!
    @IBOutlet weak var postImageView: CustomizableImageView!
    @IBOutlet weak var postImageView2: CustomizableImageView!
    @IBOutlet weak var postImageView3: CustomizableImageView!
    @IBOutlet weak var postButton: UIButtonX!
    @IBOutlet weak var locationButton: CustomizableButton!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var enterZipcode: IQTextView!
    @IBOutlet weak var chooseCategoryButton: CustomizableButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var presentDetailView: CustomizableButton!
    @IBOutlet weak var errorPhotoLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var detailsIcon: UIImageView!
    @IBOutlet weak var categoriesIcon: UIImageView!
    @IBOutlet weak var hashtagIcon: UIImageView!
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
    
    @IBOutlet weak var errorLabelCategory: CustomLabel!
    @IBOutlet weak var errorLabelLocation: CustomLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savingBackground.alpha = 0
        PicturesView.alpha = 0 
        
        errorLabelCategory.isHidden = true
        errorLabel.isHidden = true
        errorLabelLocation.isHidden = true
        errorPhotoLabel.isHidden = true
        button2.alpha = 0
        button3.alpha = 0
        postImageView.alpha = 1
        postImageView2.alpha = 0
        postImageView3.alpha = 0
        locationViewBand.alpha = 0
        keywordCollection.alpha = 0
        geoFireRef = Database.database().reference().child("postLocations")
        geoFire = GeoFire(firebaseRef: geoFireRef)
        keywordCollection.delegate = self
        keywordCollection.dataSource = self
        collectionCategories.dataSource = self
        collectionCategories.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionCategories.alpha = 0
        details.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.detailsAlpha))
        enterZipcode.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.per))
        
        grabPhotos()
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
        
        details.alpha = 0
        
        self.locationManager.delegate = self
    }
    
    func detailsAlpha() {
        details.alpha = 0
        chooseCategoryButton.alpha = 1
        keyword.alpha = 1
        
        chooseCategoryButton.alpha = 1
        details.alpha = 0
        hashtagIcon.alpha = 1
        categoriesIcon.alpha = 1
        presentDetailView.alpha = 1
        detailsIcon.alpha = 1
        presentDetailView.setTitle("\(details.text!)", for: .normal)
        view.endEditing(true)
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func dismissAddPost(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    ///// CATEGORIES PICKER
    
    @IBAction func enterDetails(_ sender: Any) {
        keyword.alpha = 0
        chooseCategoryButton.alpha = 0
        details.alpha = 1
        hashtagIcon.alpha = 0
        categoriesIcon.alpha = 0
        presentDetailView.alpha = 0
        detailsIcon.alpha = 0
        
    }
    
    @IBAction func presentKeywordCollection(_ sender: AnyObject) {
        
        keywordCollection.alpha = 1
        keywordCollection.reloadData()
        presentDetailView.alpha = 0
        detailsIcon.alpha = 0
    }
    @IBAction func presentCategories(_ sender: Any) {
        self.collectionCategories.alpha = 1
        self.presentDetailView.alpha = 0
        self.keywordCollection.alpha = 0
        self.keyword.alpha = 0
        hashtagIcon.alpha = 0
        self.details.alpha = 0
        detailsIcon.alpha = 0
    }
    @IBAction func presentLocationView(_ sender: AnyObject) {
        
        locationViewBand.alpha = 1
        locationButton.alpha = 0
        errorLabelLocation.isHidden = true
        
    }
    
    ////// location
    
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
        }}
    
    
    
    
    
    //// PicturesView
    
    var imageArray = [UIImage]()
    
    func grabPhotos() {
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.version = .original
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        //   requestOptions.normalizedCropRect = (0.0, 0.0)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 65
        
        
        
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            
            for i in 0..<fetchResult.count {
                
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    image, error in
                    self.imageArray.append(image!)
                })}} else {
            self.collectionView?.reloadData()
        }}
    
    
    
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == self.collectionCategories  {
            return cellIdentifiers.count
            
            
            
        }  else  if collectionView == self.keywordCollection {
            switch self.chooseCategoryButton.titleLabel!.text! {
                
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
                return 1 }}
            
            
        else   {
            return imageArray.count }    }
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionCategories {
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.item], for: indexPath)
        }
            
        else if collectionView == self.collectionView  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
            let Cam = cell.viewWithTag(1) as! UIImageView
            Cam.image = imageArray[indexPath.row]
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keywordCell", for: indexPath as IndexPath) as! keywordCell
            
            switch self.chooseCategoryButton.titleLabel!.text! {
                
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
                
            case "choose category":
                cell.keywords.text! = self.miscellaneousWords[indexPath.item]
                return cell;
                
            default:
                cell.keywords.text! = "please first choose a category"
                return cell
            }}}
    
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            if collectionView.cellForItem(at: indexPath) != nil {
                
                if self.switch1.isOn == true {
                    
                    self.postImageView.image = self.imageArray[indexPath.item]
                    button1.alpha = 0
                    button2.alpha = 1
                    button3.alpha = 0
                    self.switch1.isOn = false
                    self.picturesOut()
                    self.PicturesView.alpha = 0
                    self.postButton.alpha = 0
                    self.savingBackground.alpha = 1
                    self.savingPost.text! = "one moment please"
                    self.checkMark.image = #imageLiteral(resourceName: "loading")
                }
                else if switch2.isOn == true {
                    
                    self.postImageView2.image = self.imageArray[indexPath.item]
                    button1.alpha = 0
                    button2.alpha = 0
                    button3.alpha = 1
                    self.switch2.isOn = false
                    self.picturesOut()
                    self.PicturesView.alpha = 0
                    self.savingBackground.alpha = 1
                    self.savingPost.text! = "one moment please"
                    self.checkMark.image = #imageLiteral(resourceName: "loading")
                    
                    self.postButton.alpha = 0
                } else if switch3.isOn == true {
                    
                    self.postImageView3.image = self.imageArray[indexPath.item]
                    button1.alpha = 0
                    button2.alpha = 0
                    button3.alpha = 0
                    self.picturesOut()
                    self.PicturesView.alpha = 0
                    self.savingBackground.alpha = 1
                    self.savingPost.text! = "one moment please"
                    self.checkMark.image = #imageLiteral(resourceName: "loading")
                    self.postButton.alpha = 0
                }}}
            
            
            
        else if collectionView == self.keywordCollection {
            
            switch self.chooseCategoryButton.titleLabel!.text! {
                
                
            case "     choose category":
                
                self.keyword.setTitle("first choose category", for: .normal)
            case "appliances":
                self.keyword.setTitle("\(self.appliancesWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "clothing & accesories":
                self.keyword.setTitle("\(self.clothingWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "electronics":
                self.keyword.setTitle("\(self.electronicsWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "furniture":
                self.keyword.setTitle("\(self.furnitureWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "household items":
                self.keyword.setTitle("\(self.householdWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "sporting goods":
                self.keyword.setTitle("\(self.sportingWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "toys & games":
                self.keyword.setTitle("\(self.toysWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "home improvement":
                self.keyword.setTitle("\(self.homeimprovementWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
            case "miscellaneous":
                self.keyword.setTitle("\(self.miscellaneousWords[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
                
            default:
                self.keyword.setTitle("\(self.cellIdentifiers[indexPath.item])", for: .normal)
                keywordCollection.alpha = 0
                presentDetailView.alpha = 1
                detailsIcon.alpha = 1
                errorLabelCategory.text = ""
                
            }}
            
            
            
        else if collectionView == self.collectionCategories {
            self.chooseCategoryButton.setTitle("\(self.cellIdentifiers[indexPath.item])", for: .normal)
            self.collectionCategories.alpha = 0
            self.presentDetailView.alpha = 1
            self.detailsIcon.alpha = 1
            keyword.alpha = 1
            hashtagIcon.alpha = 1
            errorLabel.text = ""
            self.keywordCollection.reloadData()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.pushTomainView()
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
        self.show(vc, sender: nil)
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil) }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if self.switch1.isOn == true {
            self.postImageView.image = image
            button1.alpha = 0
            button2.alpha = 1
            self.switch1.isOn = false
            self.picturesOut()
        }
        else if switch2.isOn == true {
            self.postImageView2.image = image
            button2.alpha = 0
            button3.alpha = 1
            self.picturesOut()
        }else if switch3.isOn == true {
            self.postImageView3.image = image
            button3.alpha = 0
            self.picturesOut()}
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func photosIn(_ sender: UIButton) {
        
        switch sender {
        case button1:
            
            PicturesView.alpha = 1
            errorPhotoLabel.alpha = 0
            errorPhotoLabel.isHidden = true
            switch1.isOn = true;
            
        case button2:
            PicturesView.alpha = 1
            errorPhotoLabel.alpha = 0
            switch2.isOn = true;
            
            
        case button3:
            
            PicturesView.alpha = 1
            errorPhotoLabel.alpha = 0
            
            
            switch3.isOn = true;
            
        default: break;
            
        }}
    
    
    func picturesOut() {
        let postId = NSUUID().uuidString
        let image1 = self.postImageView.image
        let image2 = self.postImageView2.image
        let image3 = self.postImageView3.image
        let postThumb = self.postImageView.image?.resized(withPercentage: 0.5)
        
        
        let imageData1 = image1?.jpeg(.highest)
        let imageData2 = UIImageJPEGRepresentation(image2!, CGFloat(1))
        let imageData3 = UIImageJPEGRepresentation(image3!, CGFloat(1))
        let postThumbData = postThumb?.jpeg(.lowest)
        
        
        
        
        
        uploadImageToFirebase(postId: postId, imageData1: imageData1!, imageData2:imageData2!, imageData3: imageData3!, postThumb: postThumbData!, completion: { (url) in
            
            
            
        })
        
        
        if postImageView.image != UIImage(named: "photoPlaceholder") {
            self.postImageView2.alpha = 1
            button1.alpha = 0
            button2.alpha = 1
            button3.alpha = 0
            
        }
        
        if postImageView2.image != UIImage(named: "photoPlaceholder") {
            postImageView3.alpha = 1
            button1.alpha = 0
            button2.alpha = 0
            button3.alpha = 1
            
            
        };   if postImageView3.image != UIImage(named: "photoPlaceholder") {
            
            button1.alpha = 0
            button2.alpha = 0
            button3.alpha = 0
        }
        
        
        // PicturesView.alpha = 0
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
        
        
    }
    
    func uploadImageToFirebase(postId: String, imageData1: Data, imageData2: Data, imageData3:Data, postThumb:Data, completion: @escaping (URL)->()){
        
        
        
        
        let postThumbPath = "postImages/\(postId)postThumb.jpg"
        let postThumbRef = storageRef.child(postThumbPath)
        
        let postImagePath1 = "postImages/\(postId)image1.jpg"
        let postImageRef1 = storageRef.child(postImagePath1)
        
        let postImagePath2 = "postImages/\(postId)image2.jpg"
        let postImageRef2 = storageRef.child(postImagePath2)
        
        
        let postImagePath3 = "postImages/\(postId)image3.jpg"
        let postImageRef3 = storageRef.child(postImagePath3)
        
        
        
        let postImageMetadata = StorageMetadata()
        postImageMetadata.contentType = "image/jpeg"
        
        
        
        
        postThumbRef.putData(postThumb, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postThumbURL = newPostImageMD?.downloadURL()
                {
                    self.thumbLink = "\(postThumbURL)"
                    completion(postThumbURL) }
            }}
        
        postImageRef1.putData(imageData1, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL1 = newPostImageMD?.downloadURL()
                {
                    self.poza1 = "\(postImageURL1)"
                    print(self.poza1)
                    completion(postImageURL1) }
            }
        }
        
        postImageRef2.putData(imageData2, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL2 = newPostImageMD?.downloadURL()  {
                    
                    if self.postImageView2.image == UIImage(named: "photoPlaceholder") {
                        self.poza2 = "no image"
                        
                    }else {
                        self.poza2 = "\(postImageURL2)"
                        completion(postImageURL2) }
                }
            }
        }
        
        postImageRef3.putData(imageData3, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let postImageURL3 = newPostImageMD?.downloadURL() {
                    if self.postImageView3.image == UIImage(named: "photoPlaceholder") {
                        self.poza3 = "no image"
                        
                    }else {
                        self.poza3 = "\(postImageURL3)"
                        completion(postImageURL3) }
                    
                }
                
            }
        }
    }
    
    @IBAction func savePost(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        func checkSave() {
            if self.keyword.titleLabel!.text! == "   choose a keyword" {
                errorLabelCategory.text = "!"
                
                errorLabelCategory.isHidden = false
            } else {
                checkCategory()
            }
        }
        
        func checkCategory() {
            if self.chooseCategoryButton.titleLabel!.text! == "   choose category"   {
                errorLabel.text = "!"
                errorLabel.isHidden = false
            } else {
                print("category ok")
            }
        }
        
        func checkLocation() {
            if self.locationButton.titleLabel!.text! == "Location" {
                errorLabelLocation.text = "!"
                //    postButton.isEnabled = false
                errorLabelLocation.isHidden = false
            }
            else {
                print("location ok")
            }
        }
        func checkPicture() {
            if postImageView.image == UIImage(named: "photoPlaceholder") {
                errorPhotoLabel.text = "Add a photo."
                errorPhotoLabel.isHidden = false
            }}
        
        
        
        func postIt() {
            if postImageView.image == UIImage(named: "photoPlaceholder") || self.locationButton.titleLabel!.text! == "Location" || keyword.titleLabel!.text! == "   choose a keyword" || self.chooseCategoryButton.titleLabel!.text! == "   choose category" {
                checkPicture()
                checkSave()
                checkCategory()
                checkLocation()
                
                print("nu-i gata")
            }  else if keyword.titleLabel!.text! != "   choose a keyword" && self.chooseCategoryButton.titleLabel!.text! != "   choose category"  && self.locationButton.titleLabel!.text! != "Location" &&  postImageView.image != UIImage(named: "photoPlaceholder") {
                
                let allPosts = "allPosts"
                let postTitle = keyword.titleLabel!.text!
                let postDetails = details.text!
                let postCategory = chooseCategoryButton.titleLabel!.text!
                let postId = NSUUID().uuidString
                let postDate = NSDate().timeIntervalSince1970 as NSNumber
                let city =  locationButton.titleLabel!.text!
                var url2: String! = ""
                let post = Post(allPosts: allPosts,
                                postId: postId,
                                userId: Auth.auth().currentUser!.uid,
                                postImageURL1: poza1,
                                postImageURL2: poza2,
                                postImageURL3: poza3,
                                postThumbURL: thumbLink,
                                postDate: postDate,
                                location: "coordinates",
                                postTitle: postTitle,
                                postDetails: postDetails,
                                postCategory: postCategory,
                                city: city,
                                latit: currentLocation.latitude,
                                longit: currentLocation.longitude)
                
                
                func geoset() {
                    let coordinates = postIdLocation.components(separatedBy: ":")
                    print(coordinates)
                    
                    let location = CLLocation(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
                    geoFire!.setLocation(location, forKey: postId) { (error) in
                        if (error != nil) {
                            debugPrint("An error occured: \(String(describing: error))")
                        } else {
                            print("Saved location successfully!")
                        }
                    }
                }
                
                let postRef = databaseRef.child("posts").child(postId)
                postRef.setValue(post.serialized) { (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        geoset()
                        
                        print(postId)
                    }
                }
                
                func delay(delay: Double, closure: @escaping () -> ()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        closure()
                    }
                }
                
                delay(delay: 2) {
                    self.savingBackground.alpha = 1
                    self.checkMark.image = #imageLiteral(resourceName: "Done")
                    self.savingPost.text! = "post saved succesfully"
                    
                    delay(delay: 3) {
                        self.pushTomainView()
                    }
                    
                }
            }
        }
        
        postIt()
    }

    func editAlertGone() {
        errorLabel.isHidden = true
        view.endEditing(true)
    }
}

extension AddPostVC:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
            let itemsPerRow: CGFloat = 3.2
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        } else {
            return CGSize(width: 150, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            
            
            let sectionInsets = UIEdgeInsets(top: 1, left: 1.0, bottom: 1, right: 1)
            return sectionInsets
        } else {
            let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            return sectionInsets
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            return sectionInsets.left
        } else {
            let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            return sectionInsets.left
            
        }
    }
}

extension UIImage {
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
    }}
