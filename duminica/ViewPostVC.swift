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
    @IBOutlet weak var inputTextField: IQTextView!
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var locationLabel: CustomLabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var viewPostTitle: UILabel!
    @IBOutlet weak var tweeterButton: CustomizableButton!
    @IBOutlet weak var facebookButton: CustomizableButton!
    @IBOutlet weak var doneButton: CustomizableButton!
    @IBOutlet weak var donButton: UIButtonX!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var aDouaHarta: MKMapView!
    @IBOutlet weak var toLargerMap: UIButton!
    @IBOutlet weak var titleFromCustCell: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var shareOptions: UIButton!
    @IBOutlet weak var mapViewHidingView: UIView!
    @IBOutlet var largerMapVIew: UIView!
    @IBOutlet weak var largerMapMapView: MKMapView!
    @IBOutlet var contactLabel: UILabel!
    
    @IBOutlet weak var imagesCollecionView: UICollectionView!
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var sharingHeight: NSLayoutConstraint!
    @IBOutlet weak var similarItemsHeight: NSLayoutConstraint!
    
    var passPost: Post!
    
    var sweets: [Post] = [Post]()
    var filteredSweets = [Post] ()
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
        case mapView
        case postDetails
        case sharing
        case similarItems
        case none
    }
    
    private var currentOption: OpenedOption = .none
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        //pushTomainView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPost()
        self.collectionViewCategory.delegate = self
        self.collectionViewCategory.dataSource = self
        
        self.facebookButton.alpha = 0
        self.tweeterButton.alpha = 0
        
        postDetaliiView.alpha = 0
        keywordLabel.text! = "\((passPost?.title)!)"
        self.useridFromDatabase = "\((passPost?.ownerId)!)"
        viewPostTitle.text! = "\((passPost?.category.rawValue) ?? "")"
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
        
        self.databaseRef.child("ios_users").child(self.useridFromDatabase).child("credentials").child("name").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.contactLabel.text = "contact \(snapshot.value as? String ?? "")"
            }
        })

        inputTextField.alpha = 1
        
        mapView.delegate = self
        aDouaHarta.delegate = self
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval((passPost?.date)!))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
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
        //       postUserId.text! = (passPost?.userId)!
        postdetalii.text! = (passPost?.details)!
        
        // self.postdetalii.isHidden = false
        self.postdetalii.clipsToBounds = true
        viewMaps()
        
        mapView.alpha = 1
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(page)
            
        }

        pageControl.currentPage = 0
        
        pageControl.defersCurrentPageDisplay = true
        pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
    }
    
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
        case .mapView:
            mapViewHeight.constant = UIScreen.main.bounds.width
            mapViewHidingView.alpha = 0
        case .postDetails:
            postDetailsHeight.constant = UILabel.heightFor(text: passPost.details ?? "", font: postdetalii.font, width: postdetalii.frame.width)
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
        mapViewHeight.constant = imagesCollecionView.frame.height
        mapViewHidingView.alpha = 0.5
        postDetailsHeight.constant = 0
        postdetalii.alpha = 0
        sharingHeight.constant = 0
        similarItemsHeight.constant = 0
        collectionViewCategory.alpha = 0
    }
    
    func changePage(sender: AnyObject) -> () {
        //let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        //scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
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
    
    func fetchAllPost(completion: @escaping ([Post])->()) {
        
        let postsRef = databaseRef.child("posts").queryOrdered(byChild: "latit").queryStarting(atValue: ((self.passPost?.latitude)! - 1)).queryEnding(atValue: ((self.passPost?.latitude)! + 1))
        postsRef.observe(.value, with: { (snapshot) in
            
            var postArray = [Post]()
            for podddst in snapshot.children {
                
                if let postObject = Post(snapshot: podddst as! DataSnapshot) {
                    postArray.append(postObject)
                }
            }
            completion(postArray)
            self.collectionViewCategory.reloadData()
            
            
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
    }
    
    private func fetchAllPost(){
        fetchAllPost {(posts) in
            self.sweets = posts
            self.filteredSweets = self.sweets.filter {
                $0.category == self.passPost?.category && $0.longitude.isLessThanOrEqualTo( ((self.passPost?.longitude)! + 1))
                
            }
            
            self.filteredSweets.sort(by: { (post1, post2) -> Bool in
                Int(post1.date) > Int(post2.date)
            })
            
            self.collectionViewCategory.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSweets.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
        
        
        let sweet = filteredSweets[indexPath.row]
        
        cell.titleCell.text = sweet.category.rawValue.capitalized
        
        
        cell.imageCell.sd_setImage(with: sweet.logoUrl)
        cell.configureCell(post: self.filteredSweets[indexPath.item])
        
        
        cell.tag = indexPath.item
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        postDelegate?.selectedPost(post: self.filteredSweets[indexPath.item])
        self.passPost = self.filteredSweets[indexPath.item]
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
                toSimilarObjects?.passPost = filteredSweets[indexPath.row]
            }
        } else if segue.identifier == "ShowChatVC",
            let vc = segue.destination as? ChatVC,
            let chatId = sender as? String,
            let post = self.passPost {
            vc.post = post
            vc.roomId = chatId
            vc.currentUser = currentUser
        }
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
        
        selectOption(.mapView)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        let location = passPost.location
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 700)
        mapView.add(diskOverlay)
        mapView.showsUserLocation = true
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
    
    func postuploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                let data = ["location": reference.parent!.key]
                Database.database().reference().child("ios_users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                Database.database().reference().child("ios_users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                self.saveToWishList()
                completion(true)
            })
        }
    }
    
    func takeToAccount(){
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! AccountVC
        self.show(accountVC, sender: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        
        self.aDouaHarta.mapType = MKMapType.hybrid
        self.aDouaHarta.showsUserLocation = false
        self.locationManager.delegate = nil
        self.viewMap = nil
    }
}

fileprivate extension UILabel {
    static func heightFor(text:String, font:UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}
