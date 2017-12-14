import Foundation
import UIKit
import Firebase
import SDWebImage
import MapKit
import CoreLocation
import Social

class ViewPostVC: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PostDelegate {
    
    @IBOutlet weak var antet: UIViewX!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet var viewMap: UIView!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var locationLabel: CustomLabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var viewPostTitle: UILabel!
    @IBOutlet weak var tweeterButton: CustomizableButton!
    @IBOutlet weak var facebookButton: CustomizableButton!
    @IBOutlet weak var doneButton: CustomizableButton!
    @IBOutlet weak var donButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var toLargerMap: UIButton!
    @IBOutlet weak var titleFromCustCell: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shareOptions: UIButton!
    @IBOutlet weak var mapViewHidingView: UIView!
    @IBOutlet var largerMapView: UIView!
    @IBOutlet weak var largerMapMapView: MKMapView!
    @IBOutlet var contactButtonOutlet: UIButton!
    
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet weak var imagesCollecionView: UICollectionView!
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var sharingHeight: NSLayoutConstraint!
    @IBOutlet weak var similarItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var similarItemsTitleHeight: NSLayoutConstraint!
    
    var passPost: Post!
    
    var similarPosts: [Post] = []
    var postDelegate: PostDelegate?
    
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var isChecked = true
    var useridFromDatabase: String!
    var linkPic: String!
    var items = [Message]()
    var currentUser: User?
    var databaseRef: DatabaseReference! {return Database.database().reference()}
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    @IBOutlet weak var postDetaliiView: UIViewX!
    @IBOutlet var postdetalii: UILabel!

    private enum OpenedOption {
        case postDetails
        case sharing
        case similarItems
        case none
    }
    
    private var currentOption: OpenedOption = .none
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSimilarPosts()
        self.collectionViewCategory.delegate = self
        self.collectionViewCategory.dataSource = self
        
        postDetailsHeight.constant = 0
        sharingHeight.constant = 0
        similarItemsHeight.constant = 0
        similarItemsTitleHeight.constant = 0
        
        postdetalii.text = passPost.details
        viewPostTitle.text = passPost.title
        
        if passPost.imageURLs.count > 1 {
            pageControl.numberOfPages = passPost.imageURLs.count
        } else {
            pageControl.isHidden = true
        }
        
        keywordLabel.text! = "\((passPost?.title)!)"
        self.useridFromDatabase = "\((passPost?.ownerId)!)"
        self.databaseRef.child("ios_users").child(self.useridFromDatabase).child("credentials").child("email").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                let removal: [Character] = [".", "#", "$", "@"]
                let unfilteredCharacters = ("\(snapshot.value! as! String)").characters
                let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                let filtered = String(filteredCharacters)
                self.databaseRef.child("ios_users").child("emailProfilePictures").child("\(filtered)").observe(.value, with: { (snapshot) in
                    if snapshot.exists(){
                        self.profilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
                    } else {
                        self.databaseRef.child("ios_users").child(self.useridFromDatabase).child("credentials").child("id").observe(.value, with: { (snapshot) in
                            if snapshot.exists() {
                                self.profilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                                
                                print(snapshot.value!)
                            }
                        })
                    }
                })
            }
        })
        
        self.databaseRef.child("ios_users").child(passPost.ownerId).child("credentials").child("name").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.contactLabel.text = "contact \(snapshot.value as? String ?? "")"
            }
        })
        
        mapView.delegate = self
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval((passPost?.date)!))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            titleFromCustCell.text = "     posted now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute == 0 {
            titleFromCustCell.text! = "     posted \(differenceOfDate.second!) seconds ago"
            
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            titleFromCustCell.text! = "     posted \(differenceOfDate.minute!) minutes ago"
            
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            titleFromCustCell.text! = "     posted \(differenceOfDate.hour!) hours ago"
            
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            titleFromCustCell.text! = "     posted \(differenceOfDate.day!) days ago"
            
        }else if differenceOfDate.weekOfMonth! > 0 {
            titleFromCustCell.text! = "     posted \(differenceOfDate.weekOfMonth!) weeks ago"
            
        }
        
        locationLabel.text! = "          \((passPost?.locationTitle)!)"
        
        postdetalii.clipsToBounds = true
        viewMaps()
        
        mapView.alpha = 1

        pageControl.currentPage = 0
        
        pageControl.defersCurrentPageDisplay = true
        pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Adding map view
        view.addSubview(largerMapView)
        largerMapView.frame = CGRect.init(x: 0,
                                          y: -UIScreen.main.bounds.height,
                                          width: UIScreen.main.bounds.width,
                                          height: UIScreen.main.bounds.height)
        largerMapMapView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        largerMapView.removeFromSuperview()
    }
    
    private func selectOption(_ newOption: OpenedOption) {
        
        closeAllCollections()
        
        guard currentOption != newOption else {
            currentOption = .none
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })

            return
        }
        
        switch newOption {
        case .postDetails:
            postDetailsHeight.constant = UILabel.heightFor(text: passPost.details ?? "", font: postdetalii.font, width: postdetalii.frame.width) + 8
            postdetalii.alpha = 1
        case .sharing:
            sharingHeight.constant = 45
        case .similarItems:
            similarItemsHeight.constant = 139
            collectionViewCategory.alpha = 1
        case .none:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        currentOption = newOption
    }
    
    private func closeAllCollections() {
        postDetailsHeight.constant = 0
        postdetalii.alpha = 0
        sharingHeight.constant = 0
        similarItemsHeight.constant = 0
        collectionViewCategory.alpha = 0
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.green
            circleRenderer.alpha = 0.3
            return circleRenderer
        }
        else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func fetchSimilarPosts() {
        
        databaseRef
            .child("ios_posts")
//            .queryEqual(toValue: passPost.category.rawValue, childKey: "category")
            .observe(.value, with: { (snapshot) in
                print(snapshot.key)
                if let data = snapshot.children.allObjects as? [DataSnapshot] {
                    for post in data {
                        if let postObject = Post(snapshot: post),
                            postObject.id != self.passPost.id {
                            self.similarPosts.append(postObject)
                        }
                    }
                    
                    if !self.similarPosts.isEmpty {
                        self.similarItemsTitleHeight.constant = 45
                        self.similarItemsHeight.constant = 139
                        self.collectionViewCategory.reloadData()
                    }
                }
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === imagesCollecionView {
            return passPost.imageURLs.count
        }
        
        return similarPosts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === imagesCollecionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
            
            cell.cellImageView.sd_setImage(with: passPost.imageURLs[indexPath.row])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
        
        
        let post = similarPosts[indexPath.row]
        
        cell.titleCell.text = post.category.rawValue.capitalized
        
        cell.imageCell.sd_setImage(with: post.logoUrl)
        cell.configureCell(post: post)
        if let userPosition = AppDelegate.session.lastLocation {
            let postLocation = CLLocation(latitude: post.latitude,
                                          longitude: post.longitude)
            let userLocation = CLLocation(latitude: userPosition.latitude, longitude: userPosition.longitude)
            
            let distance = Int(userLocation.distance(from: postLocation))
            if distance > 1000 {
                cell.titleCell.text = "\(distance/1000) km"
            } else {
                cell.titleCell.text = "\(distance) m"
            }
            
        }
        
        cell.tag = indexPath.item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView === imagesCollecionView {
            return
        }
        
        postDelegate?.selectedPost(post: self.similarPosts[indexPath.item])
        self.passPost = self.similarPosts[indexPath.item]
    }
    
    func selectedPost(post: Post) {
        self.performSegue(withIdentifier: "fromSimilar   ", sender: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReportPage" {
            let postDetailPage = segue.destination as? report
            postDetailPage?.passPostEdit = passPost
            
        } else if segue.identifier == "fromSimilar" {
            
            let toSimilarObjects = segue.destination as? ViewPostVC
            if let indexPath = self.collectionViewCategory?.indexPath(for: sender as! UICollectionViewCell) {
                toSimilarObjects?.passPost = similarPosts[indexPath.row]
            }
        } else if segue.identifier == "ShowChatVC",
            let navVc = segue.destination as? UINavigationController,
            let vc = navVc.viewControllers.first as? ChatVC,
            let chatId = sender as? String,
            let post = self.passPost {
            vc.post = post
            vc.roomId = chatId
            vc.currentUser = currentUser
        }
    }
    
    @IBAction func removeLargerMap(_ sender: CustomizableButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.largerMapView.frame = CGRect(x: 0,
                                              y: -UIScreen.main.bounds.height,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height)
        })
    }
    
    @IBAction func contactUserButtonPressed(_ sender: UIButtonX) {
        ChatManager.shared.checkIfChatExists(post: passPost, completion: { (chatId) in
            self.performSegue(withIdentifier: "ShowChatVC", sender: chatId ?? ChatManager.shared.initiateChat(with: self.passPost))
        })
        
    }
    
    @IBAction func saveToList(_ sender: Any) {
        self.saveToWishList()
    }
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        
        vc?.add(URL(string: ("https://stackoverflow.com/questions/41902776/facebook-login-using-firebase-swift-ios")))
        vc?.setInitialText("Check out this item from Cerc")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func shareOnTwitter(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        vc?.add(URL(string: ("https://stackoverflow.com/questions/41902776/facebook-login-using-firebase-swift-ios")))
        vc?.setInitialText("Check out this item from Cerc")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func shareOptionsAction(_ sender: Any) {
        selectOption(.sharing)
    }
    
    @IBAction func presentDetalii(_ sender: Any) {
        selectOption(.postDetails)
    }
    
    @IBAction func toLargerMapAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.largerMapView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height)
        })
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        let location = passPost.location
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        largerMapMapView.setRegion(region, animated: true)
        let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 700)
        largerMapMapView.add(diskOverlay)
        largerMapMapView.showsUserLocation = true
    }
    
    @IBAction func selectPage(_ sender: UIPageControl) {
        let page = sender.currentPage
        imagesCollecionView.contentOffset.x = UIScreen.main.bounds.width * CGFloat(page)
    }
    
    func viewMaps() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        let location = passPost.location
        print(location.latitude)
        print(location.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 700)
        self.mapView.add(diskOverlay)
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    func saveToWishList() {
        if  let currentUserID = Auth.auth().currentUser?.uid,
            let postId = self.passPost?.id {
            databaseRef.child("ios_wishlist").child(currentUserID).childByAutoId().setValue(postId)
        }
    }
    
    func takeToAccount(){
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! AccountVC
        self.show(accountVC, sender: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        
        self.locationManager.delegate = nil
        self.viewMap = nil
    }
}

extension ViewPostVC:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView === self.imagesCollecionView {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        
        return CGSize(width: 139, height: 139)
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
