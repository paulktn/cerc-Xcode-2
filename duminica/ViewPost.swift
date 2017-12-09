import Foundation
import UIKit
import Firebase
import SDWebImage
import MapKit
import CoreLocation
import Social



class ViewPost: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PostDelegate {
    
    
    
    @IBOutlet weak var antet: UIViewX!
    
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet var viewMap: UIView!
    @IBOutlet weak var inputTextField: IQTextView!
    
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var locationLabel: CustomLabel!
    @IBOutlet var pageControl: UIPageControl!
    
   // @IBOutlet var backgroundViewPost: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
 
    @IBOutlet weak var viewPostTitle: UILabel!
    
    @IBOutlet weak var tweeterButton: CustomizableButton!
    
    @IBOutlet weak var facebookButton: CustomizableButton!
    
    @IBOutlet var contact: CustomizableButton!
    
    @IBOutlet weak var doneButton: CustomizableButton!
    
    @IBOutlet weak var donButton: UIButtonX!
    
  
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    @IBOutlet var largerMap: UIView!
    
    @IBOutlet weak var aDouaHarta: MKMapView!
    
    @IBOutlet weak var toLargerMap: UIButton!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet weak var titleFromCustCell: UILabel!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var shareOptions: UIButton!
    
    
    
    
    var passPost: Post?
    
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
    var geoLatitudine = Double()
    var geoLongitudine = Double()
    var databaseRef: DatabaseReference!
    {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
 
    
    
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var postDetaliiView: UIViewX!
    
    @IBOutlet var postdetalii: UILabel!
    
    
    @IBAction func close(_ sender: AnyObject) {
       pushTomainView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPost()
        self.collectionViewCategory.delegate = self
        self.collectionViewCategory.dataSource = self
        
        self.facebookButton.alpha = 0
        self.tweeterButton.alpha = 0
      postDetaliiView.alpha = 0
        keywordLabel.text! = "\((passPost?.postTitle)!)"
        self.useridFromDatabase = "\((passPost?.userId)!)"
        viewPostTitle.text! = "\((passPost?.category.rawValue) ?? "")"
        self.databaseRef.child("users").child(self.useridFromDatabase).child("credentials").child("email").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                
                let removal: [Character] = [".", "#", "$", "@"]
                
                let unfilteredCharacters = ("\(snapshot.value! as! String)").characters
                
                let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                
                let filtered = String(filteredCharacters)
                
        self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.profilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
            } else {
                
                
                self.databaseRef.child("users").child(self.useridFromDatabase).child("credentials").child("id").observe(.value, with: { (snapshot) in
                    if snapshot.exists() {
                        self.profilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                        
                        print(snapshot.value!)}}
                )}})}})
        
        self.databaseRef.child("users").child(self.useridFromDatabase).child("credentials").child("name").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.contact.setTitle("          contact \(snapshot.value! as! String)", for: .normal)
            } else {}})
        
        
        
        
        
       inputTextField.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.sendMessageFromKeyboard))
        
        //IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        
        
        //   locateIt()
        inputTextField.alpha = 1
      
     //   donButton.contentHorizontalAlignment = .left
        
        
        //    inputTextField.delegate = self
        
       
      //  contact.contentHorizontalAlignment = .left
        
        mapView.delegate = self
        aDouaHarta.delegate = self
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval((passPost?.postDate)!))
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
        
        locationLabel.text! = "          \((passPost?.city)!)"
        //       postUserId.text! = (passPost?.userId)!
        postdetalii.text! = (passPost?.postDetails)!
       
       // self.postdetalii.isHidden = false
    self.postdetalii.clipsToBounds = true
        viewMaps()
        
        mapView.alpha = 1
        
        blurEffect.alpha = 0
        //  setupLayer()
        
        var scrollViewHeight = self.scrollView.frame.height
        var scrollViewWidth = self.scrollView.frame.width
        scrollView.isPagingEnabled = true
        
        scrollViewWidth = self.scrollView.frame.width
        scrollViewHeight = self.scrollView.frame.height
        
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let page = scrollView.contentOffset.x / scrollView.frame.size.width
            pageControl.currentPage = Int(page)
            
        }
        
        
        let imgOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))

        let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imgThree = UIImageView(frame: CGRect(x: scrollViewWidth*2, y: 0, width: scrollViewWidth, height:scrollViewHeight))
        
        imgOne.sd_setImage(with: URL(string: (passPost?.postImageURL1)!))
        imgTwo.sd_setImage(with: URL(string: (passPost?.postImageURL2)!))
        imgThree.sd_setImage(with: URL(string: (passPost?.postImageURL3)!))
        
        
        
        
        
        self.scrollView.addSubview(imgOne)
        if (passPost?.postImageURL2)! != "no image" {
            self.scrollView.addSubview(imgTwo)
            pageControl.numberOfPages = 2
            scrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
            
        }
        if (passPost?.postImageURL3)! != "no image"   {
            scrollView.contentSize = CGSize(width: scrollViewWidth * 3, height: scrollViewHeight)
            pageControl.numberOfPages = 3
            self.scrollView.addSubview(imgThree)}
        
        
        
        
        
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollViewDidScroll(scrollView)
        
        
        
        pageControl.currentPage = 0
        
        pageControl.defersCurrentPageDisplay = true
        
        
        
        pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
        
    }
    
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
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
        
        let postsRef = databaseRef.child("posts").queryOrdered(byChild: "latit").queryStarting(atValue: ((self.passPost?.latit)! - 1)).queryEnding(atValue: ((self.passPost?.latit)! + 1))
        postsRef.observe(.value, with: { (snapshot) in
            
            var postArray = [Post]()
            for podddst in snapshot.children {
                
                let postObject = Post(snapshot: podddst as! DataSnapshot)
                postArray.append(postObject)
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
                $0.category == self.passPost?.category && $0.longit.isLessThanOrEqualTo( ((self.passPost?.longit)! + 1))
            
            }
            
            self.filteredSweets.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
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
        
        
        cell.imageCell.sd_setImage(with: URL(string: sweet.postImageURL1))
        
        
        
        
        
       
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
            
        }
        
        else if segue.identifier == "fromSimilar" {
            
            let toSimilarObjects = segue.destination as? ViewPost
            if let indexPath = self.collectionViewCategory?.indexPath(for: sender as! UICollectionViewCell) {
                toSimilarObjects?.passPost = filteredSweets[indexPath.row]
            }
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
        if self.facebookButton.alpha == 0 {
             self.facebookButton.alpha = 1
        self.tweeterButton.alpha = 1
            self.flagButton.alpha = 0
        
       // self.shareOptions.alpha = 0
        } else {
            self.facebookButton.alpha = 0
            self.tweeterButton.alpha = 0
            self.flagButton.alpha = 1
        }
       
    }
    
    
    
    
    @IBAction func presentDetalii(_ sender: Any) {
        if postDetaliiView.alpha == 0 {
            postDetaliiView.alpha = 1
        } else {
            postDetaliiView.alpha = 0
        }
        
        
    }
    
   
    
    
    @IBAction func toLargerMapAction(_ sender: Any) {
        
        blurEffect.alpha = 0.8
        self.view.addSubview(largerMap)
        self.largerMap.frame.size.height = (self.antet.frame.height + self.profilePic.frame.height + self.scrollView.frame.height + self.viewMap.frame.height + 10)
        let locationId = (passPost?.postId)!
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        
        
        
        
        
        
        //  let coordinates = (passPost?.location)!.components(separatedBy: ":")
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        
        let georef1 = self.databaseRef.child("postLocations").child(locationId).child("l").child("0")
        georef1.observe(.value, with: { (snapshot) in
            
            self.geoLatitudine = snapshot.value as! Double
            print(self.geoLatitudine)
        })
        let georef2 = self.databaseRef.child("postLocations").child(locationId).child("l").child("1")
        georef2.observe(.value, with: { (snapshot) in
            
            self.geoLongitudine = snapshot.value as! Double
            print(self.geoLongitudine)
            
            
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(self.geoLatitudine), longitude: CLLocationDegrees(self.geoLongitudine))
            
            print(location.latitude)
            print(location.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            
            self.aDouaHarta.setRegion(region, animated: true)
            
            
            
            // self.mapView.layer.cornerRadius = 10.0
            
            let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 700)
            self.aDouaHarta.add(diskOverlay)
            self.aDouaHarta.showsUserLocation = true
            
        } )
        
        
        
        
    }
    
    @IBAction func removeLargerMap(_ sender: Any) {
        self.largerMap.removeFromSuperview()
       // self.aDouaHarta.delegate = nil
        //self.aDouaHarta.removeFromSuperview()
        //self.aDouaHarta = nil
        blurEffect.alpha = 0
    }
    
    
    
    
    @IBAction func dismissExtraViews(_ sender: AnyObject) {
        self.viewMap.removeFromSuperview()
        self.messageView.removeFromSuperview()
        
    }
    
    
    
    
    
    func viewMaps() {
        
        let locationId = (passPost?.postId)!
        
        
    //    viewMap.layer.cornerRadius = 10
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        
        
        //  let coordinates = (passPost?.location)!.components(separatedBy: ":")
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.04, 0.04)
        
        let georef1 = self.databaseRef.child("postLocations").child(locationId).child("l").child("0")
        georef1.observe(.value, with: { (snapshot) in
            
            self.geoLatitudine = snapshot.value as! Double
            print(self.geoLatitudine)
        })
        let georef2 = self.databaseRef.child("postLocations").child(locationId).child("l").child("1")
        georef2.observe(.value, with: { (snapshot) in
            
            self.geoLongitudine = snapshot.value as! Double
            print(self.geoLongitudine)
            
            
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(self.geoLatitudine), longitude: CLLocationDegrees(self.geoLongitudine))
            
            print(location.latitude)
            print(location.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            
            self.mapView.setRegion(region, animated: true)
            
            
            
            // self.mapView.layer.cornerRadius = 10.0
            
            let diskOverlay: MKCircle = MKCircle.init(center: location, radius: 700)
            self.mapView.add(diskOverlay)
            
        
            
        } )
    }
    
    
    
    
    
    func doneClicked() {
        view.endEditing(true)
    //    scrollView.alpha = 1
   //     pageControl.alpha = 1
    //    titleFromCustCell.alpha = 1
        
    //    facebookButton.alpha = 1
   //     tweeterButton.alpha = 1
   //     pinterestButton.alpha = 1
        
    //    postdetalii.alpha = 1
   //     contact.alpha = 1
   //     doneButton.alpha = 1
   //     flagButton.alpha = 1
   //     flagButton.alpha = 1
        
        
    }
    
    func postcomposeMessage(content: Any)  {
        let message = Message.init(content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        postsend(message: message, toID: (passPost?.userId)!, completion: {(_) in
        })
        
        
    }
    
    func postsend(message: Message, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            
            
            
            let values = ["content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
            postuploadMessage(withValues: values, toID: toID, completion: { (status) in
                completion(status)
            })
            
            
        }}
    
    
    
    func saveToWishList() {
        
        
        if  let currentUserID = Auth.auth().currentUser?.uid {
            let post = Post(allPosts: "\((self.passPost?.allPosts)!)", postId: "\((self.passPost?.postId)!)", userId: "\((self.passPost?.userId)!)", postImageURL1: "\((self.passPost?.postImageURL1)!)", postImageURL2: "\((self.passPost?.postImageURL2)!)", postImageURL3: "\((self.passPost?.postImageURL3)!)", postThumbURL: "\((self.passPost?.postThumbURL)!)",  postDate: ((self.passPost?.postDate)!), key: "\((self.passPost?.postId)!)", location: "\((self.passPost?.postId)!)", postTitle: "\((self.passPost?.postTitle)!)", postDetails: "\((self.passPost?.postDetails)!)", postCategory: self.passPost!.category.rawValue, city: "\((self.passPost?.city)!)", latit: (self.passPost?.latit)!, longit: (self.passPost?.longit)!)
        
        
        let postRef = databaseRef.child("wishlist").child(currentUserID).child("\((self.passPost?.postId)!)")
        
        postRef.setValue(post.serialized) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else { }
            }}
    }
    
  
    
    
    
    func postuploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                let data = ["location": reference.parent!.key]
                Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                self.saveToWishList()
                completion(true)
            })
}
    }
    
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
        self.show(vc, sender: nil)
    }
    
    
    
    func takeToAccount(){
        
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! AccountVC
        self.show(accountVC, sender: nil)
    }
    
    @IBAction func contactUser(_ sender: AnyObject) {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.GGGGG()
                
            } else {
                self.takeToAccount()
                
            }
        }}
    
    
    
    @IBAction func messageEdit(_ sender: AnyObject) {
        if contact.titleLabel?.text == "     send message" {
            if let text = self.inputTextField.text {
                if text.count > 0 {
                    self.postcomposeMessage(content: self.inputTextField.text!)
                    self.inputTextField.text = ""
                }}
            sender.setTitle("contact", for: .normal)
            self.inputTextField.alpha = 0
            self.mapView.alpha = 1
            //   textViewDidEndEditing(self.inputTextField)
            
            
            
        } else  {
            self.inputTextField.alpha = 1
            self.mapView.alpha = 0
            sender.setTitle("     send message", for: .normal)
            
        }
    }
    
    
    
    
    
    
    func GGGGG() {
        
        blurEffect.alpha = 0.8
        self.view.addSubview(messageView)
        
        messageView.frame.origin.y = (viewMap.frame.origin.y + viewMap.frame.height)
        
    // messageView.frame = CGRect(x:0, y: 200, width: view.frame.width, height: messageView.frame.height)
        
     //   messageView.frame = CGRect(x: 0 , y: mapView.frame.origin.y, width: view.frame.width, height: mapView.frame.height)
        
        
        
    //    inputTextField.frame = CGRect(x: 0, y: 0, width: messageView.frame.width, height: messageView.frame.height)
        
        
        
        
        
     //   inputTextField.placeholderOld = "  Type a message"
     //   scrollView.alpha = 0
     //   pageControl.alpha = 0
    //    titleFromCustCell.alpha = 0
        
    //    facebookButton.alpha = 0
   //     tweeterButton.alpha = 0
    //    pinterestButton.alpha = 0
        
   //     postdetalii.alpha = 0
    //    contact.alpha = 0
   //     doneButton.alpha = 0
   //     flagButton.alpha = 0
   //     flagButton.alpha = 0
    //    shareButton.alpha = 0
        
        
        
        
    }
    
    
    func sendMessageFromKeyboard() {
        
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.postcomposeMessage(content: self.inputTextField.text!)
                self.inputTextField.text = ""
                
                
                
                
            }
            
            
        }
        self.messageView.removeFromSuperview()
    //    scrollView.alpha = 1
    //    pageControl.alpha = 1
    //    titleFromCustCell.alpha = 1
        
   //     facebookButton.alpha = 1
    //    tweeterButton.alpha = 1
    //    pinterestButton.alpha = 1
        
     //   postdetalii.alpha = 1
   //     contact.alpha = 1
   //     doneButton.alpha = 1
   //     flagButton.alpha = 1
   //     flagButton.alpha = 1
   //     shareButton.alpha = 1
        
        blurEffect.alpha = 0
    }
    
    @IBAction func  sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.postcomposeMessage(content: self.inputTextField.text!)
                self.inputTextField.text = ""
                
                
                
                
            }
        }
        self.messageView.removeFromSuperview()
        scrollView.alpha = 1
        pageControl.alpha = 1
        titleFromCustCell.alpha = 1
        
       // facebookButton.alpha = 1
       // tweeterButton.alpha = 1
   
        
        postdetalii.alpha = 1
        contact.alpha = 1
        doneButton.alpha = 1
        flagButton.alpha = 1
        flagButton.alpha = 1
    }
    
    func removeNastyMapMemory() {
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
      
        
        
        
        
     //   self.aDouaHarta.delegate = nil
      //  self.mapView.delegate = nil
        
      //  self.aDouaHarta.removeFromSuperview()
    //    self.mapView.removeFromSuperview()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.aDouaHarta.mapType = MKMapType.hybrid
        self.mapView.mapType = MKMapType.hybrid
        
        self.aDouaHarta.showsUserLocation = false
        self.mapView.showsUserLocation = false
        
        self.locationManager.delegate = nil
        
        
        self.viewMap.removeFromSuperview()
        self.largerMap.removeFromSuperview()
        self.viewMap = nil
        self.largerMap = nil
    }
    
    
    
}


