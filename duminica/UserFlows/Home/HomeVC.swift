import UIKit
import Firebase
import CoreLocation
import Firebase
import Social

class HomeVC: UIViewController, CLLocationManagerDelegate, PostDelegate, UITextFieldDelegate, ModernSearchBarDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var searchBar: ModernSearchBar!
    @IBOutlet weak var menuBlur: UIVisualEffectView!
    @IBOutlet weak var contact: CustomizableButton!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var about: CustomizableButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var myMessages: CustomizableButton!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var myAccount: CustomizableButton!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var add: CustomizableButton!
    @IBOutlet weak var more: CustomizableButton!
    @IBOutlet weak var glass: UIViewX3!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var GhostText: String!
    var clothingUsers = [String] ()
    var furnitureUsers = [String] ()
    var electronicsUsers = [String] ()
    var appliancesUsers = [String] ()
    var householdUsers = [String] ()
    var sportingUsers = [String] ()
    var toysUsers = [String]()
    var constructionUsers = [String]()
    var miscUsers = [String]()
    var cuvinteCheie = String ()
    var allPosts: [Post] = []
    var filteredPosts: [Post] = []
    var passPost: Post?
    var final = [String]()
    var postDelegate: PostDelegate?
    var canSendLocation = true
    var textGhost: String!
    var location: CLLocation?
    var items = [Conversation]()
    var key: String!
    var locationManager = CLLocationManager()
    var mCenter: CGPoint!
    var aboutCenter: CGPoint!
    var settingsCenter: CGPoint!
    var accountCenter: CGPoint!
    var addCenter: CGPoint!
    var addingCenter: CGPoint!
    var menuBlurCenter: CGPoint!
    var cercleCenter: CGPoint!
    let someTextField = UITextField()
    let messageComposer = MessageComposer()
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    var storageRef: StorageReference! {
        return Storage.storage().reference()
    }
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5)
    let itemsPerRow: CGFloat = 2
    var nearbyUsers = [String] ()
    
    let categoryForRow: [Int: Post.Category] = [1: .clothingAndAccesories,
                                                2: .electronics,
                                                3: .furniture,
                                                4: .householdItems,
                                                5: .appliances,
                                                6: .toysAndGames,
                                                7: .homeImprovement,
                                                8: .miscellaneous,
                                                9: .sportingGoods]
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        locationManager.delegate = self
        collectionView.dataSource = self
        
        self.configureSearchBar()
        
        customizeHome()
        
        self.searchBarHeight.constant = 0
        searchBar.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.searchKey))
        tableView.tableFooterView = UIView()
        
        useCurentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cercleIn()
        customizeHome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        fetchAllPosts()
    }
    
    // MARK: - Private
    
    private func configureSearchBar(){
        
        ///Create array of string
        let suggestionList = ["blouse", "boots", "coat", "dress", "handbag", "jacket", "jeans", "pijamas","pants", "raincoat", "shirt", "suit", "shoes", "skirt", "slacks", "shorts", "snowsuit", "sweater", "tuxedo", "women's accesories","bed(single)", "bed(f/q/k)", "folding bed", "bedroom set", "chair", "chest", "china cabinet", "clothes closet", "coffee table", "crib", "desk", "dining room set", "dresser", "end table", "hi riser", "kitchen cabinet", "mattress", "rugs", "secretary", "sofa", "sleeper sofa", "trunk", "wardrobe", "bakeware", "bedspread/quilt", "chair/sofa cover", "coffeemaker", "curtains", "drapes", "fireplace set", "floor lamp", "glass/cup", "griddle", "kitchen utensils", "lamp", "mixer/blender", "picture/painting", "pillow", "pot/pan", "sheets", "throw rug", "towels", "vacuum","cell phone", "computer monitor", "computer desktop", "copier", "dvd", "dvd player", "radio/cd player", "printer", "tv","air conditioner", "dryer", "electric stove", "gas stove", "microwave", "refrigerator", "tv", "washing machine","bicycle", "fishing rod", "ice/roller skates", "tennis rackets", "toboggans","action figures", "cars and remote controlled", "construction toys", "doll", "educational toys", "electronics toys", "plush toys", "puzzle", "wooden toys", "measuring tool", "hammer", "electrical drill", "cutting tool", "hand saw", "electrical saw", "construction materials", "screwdriver"]
        
        func onClickItemSuggestionsView(item: String) {
            print("User touched this item: + \(item))")
        }
        
        ///Adding delegate
        self.searchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.searchBar.setDatas(datas: suggestionList)
        ///Custom design with all paramaters if you want to
        //self.customDesign()
        
    }
    
    private func getAllPosts() {
        let ref = self.databaseRef.child("ios_posts")
        
        var postsWithCorrectLatitude = [Post]()
        var postsWithCorrectLongitude = [Post]()
        
        var requestsCounter = 2 {
            didSet {
                guard requestsCounter == 0 else {return}
                for post in postsWithCorrectLongitude {
                    if let correctPost = postsWithCorrectLatitude.filter({$0.id == post.id}).first {
                        allPosts.append(correctPost)
                    }
                }
                
                tableView.reloadData()
            }
        }
        
        var latitudeQuery = ref.queryOrdered(byChild: "latitude")
        if let location = location {
           latitudeQuery = latitudeQuery
            .queryStarting(atValue: location.coordinate.latitude - 1, childKey: "latitude")
            .queryEnding(atValue: location.coordinate.latitude + 1, childKey: "latitude")
        }
        
        latitudeQuery.observe(.value, with: { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for postData in data {
                    if let post = Post(snapshot: postData) {
                        postsWithCorrectLatitude.append(post)
                    }
                }
                requestsCounter += -1
            }
        })
        
        var longitudeQuery = ref.queryOrdered(byChild: "longitude")
        if let location = location {
            longitudeQuery = longitudeQuery
                .queryStarting(atValue: location.coordinate.latitude - 1, childKey: "longitude")
                .queryEnding(atValue: location.coordinate.latitude + 1, childKey: "longitude")
        }
        
        longitudeQuery.observe(.value, with: { (snapshot) in
            if let data = snapshot.children.allObjects as? [DataSnapshot] {
                for postData in data {
                    if let post = Post(snapshot: postData) {
                        postsWithCorrectLongitude.append(post)
                    }
                }
                
                requestsCounter += -1
            }
        })
    }
    
    private func fetchAllPosts(completion: (() -> Void)? = nil) {
        var allArray = [Post]()
        
        let finalRef = self.databaseRef.child("ios_posts").queryOrdered(byChild: "latitude")
        finalRef.observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                for posts in snapshot.children.allObjects as! [DataSnapshot]   {
                    if let householdObject = Post(snapshot: posts ) {
                        
                        if let userLocation = self.location {
                            
                            let postLocation = CLLocation(latitude: householdObject.latitude,
                                                          longitude: householdObject.longitude)
                            
                            
                            let distance = Int(userLocation.distance(from: postLocation))
                            
                            if  distance < (AppDelegate.session.locationRadius ?? 30) * 1000 {
                                allArray.append(householdObject)
                            }
                        } else {
                            allArray.append(householdObject)
                        }
                    }
                }
                self.allPosts = allArray
                self.tableView.reloadData()
                completion?()
            }
        })
    }
    
    // MARK: - IBAction
    
    @IBAction func shareFB(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        
        vc?.add(URL(string: ("https://www.reuseit.io")))
        vc?.setInitialText("I found this nice app that you can donate your unwanted stuff and find lots of free items. Great for tax benefits, too.")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func shareTW(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        vc?.add(URL(string: ("https://www.reuseit.io")))
        vc?.setInitialText("I found this nice app that you can donate your unwanted stuff and find lots of free items. Great for tax benefits, too.")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func shareText(_ sender: Any) {
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            
            // Present the configured MFMessageComposeViewController instance
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.alert)
            self.present(errorAlert, animated: true)
        }
        
    }
    
    private func textField(textField: IQTextView, shouldChangeTextInRange  range: NSRange, replacementText text: String) -> Bool {
        if (text != "\n") {
            
            self.searchKey()
        }
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKey()
    }

    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.attentionButton.alpha = 1
                        self.attentionButton.setTitle("\(self.items.count)", for: .normal)
                        
                    } else if conversation.lastMessage.isRead == true {
                        self.attentionButton.alpha = 0
                    }
                }
            }
        }
    }
    
    func customizeHome(){
        attentionButton.alpha = 0
        
        menuBlur.alpha = 0
        menuView.alpha = 0
        
        more.alpha = 1
        search.alpha = 1
        appName.frame.origin.x = (self.view.frame.origin.x - appName.frame.width)
        appName.frame.origin.y = 23
        menuBlur.frame.origin.y = (menuBlur.frame.origin.y - menuBlur.frame.height)
        menuView.frame.origin.y = (menuView.frame.origin.y - menuView.frame.height)
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
    
    func useCurentLocation() {
        
        self.canSendLocation = true
        
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
            
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else {return}
        
        AppDelegate.session.lastLocation = userLocation.coordinate
        
        location = userLocation
        
        fetchAllPosts()
        
        self.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        getAllPosts()
        print("Error \(error)")
    }
    
    func cercleIn() {
        UIView.animate(withDuration: 1,  animations: {
            self.appName.center = self.glass.center
        })}
    
    
    @IBAction func showMenu(_ sender: AnyObject) {
        if more.currentImage == #imageLiteral(resourceName: "Menu") {
            
            menuBlur.alpha = 1
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut,  animations:  {
                self.menuBlur.frame = CGRect(x: 0, y: 0, width: 80, height: self.view.frame.height)
                
            })
            self.menuView.alpha = 1
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut,  animations:  {
                self.menuView.frame = CGRect(x: 0, y: 0, width: 80, height: self.view.frame.height)
                
            })
            homeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.homeButton.transform = CGAffineTransform.identity
            }, completion: nil)
            
            myMessages.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.myMessages.transform = CGAffineTransform.identity
            }, completion: nil)
            myAccount.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.myAccount.transform = CGAffineTransform.identity
            }, completion: nil)
            
            about.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.about.transform = CGAffineTransform.identity
            }, completion: nil)
            contact.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.contact.transform = CGAffineTransform.identity
            }, completion: nil)
        } else {
            
            self.more.alpha = 1
            self.appName.alpha = 1
            
            searchView.removeFromSuperview()
            self.searchBarHeight.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutSubviews()
            })
            add.alpha = 1
            self.more.setImage(#imageLiteral(resourceName: "Menu"), for: .normal)
        }
    }
    
    @IBAction func removeMenu(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.y = (self.menuView.frame.origin.y - self.menuView.frame.height)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.menuBlur.frame.origin.y = (self.menuBlur.frame.origin.y - self.menuBlur.frame.height)
        })
        add.alpha = 1
    }
    
    @IBAction func dismissMenu(_ sender: Any) {
        //dismissButton
        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.y = (self.menuView.frame.origin.y - self.menuView.frame.height)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.menuBlur.frame.origin.y = (self.menuBlur.frame.origin.y - self.menuBlur.frame.height)
        })
        add.alpha = 1
        
    }
    
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }}
    
    func takeToInfo() {
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "infoVC") as! InformationVC
        self.show(infoVC, sender: nil)
    }
    
    func takeToPostAdd(){
        let AddPostVC = self.storyboard?.instantiateViewController(withIdentifier: "Add Post") as! AddPostVC
        self.show(AddPostVC, sender: nil)
    }
    
    func takeToLogin() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginVC
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.tintColor = UIColor.black
        navVC.navigationBar.shadowImage = UIImage()
        navVC.navigationBar.isTranslucent = true
        self.present(navVC, animated: true)
    }
    
    func takeToMessages() {
        let roomVC = UIStoryboard(name: "MessagesFlow", bundle: nil)
            .instantiateInitialViewController() as! RoomVC
        let navVC = UINavigationController(rootViewController: roomVC)
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.tintColor = UIColor.white
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navVC.navigationBar.shadowImage = UIImage()
        navVC.navigationBar.isTranslucent = true
        self.present(navVC, animated: true)
    }
    
    func takeToAccount(){
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! AccountVC
        self.show(accountVC, sender: nil)
    }
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            // self.enterKeyword.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: 30)
        })
        self.add.alpha = 0
        self.more.setImage(#imageLiteral(resourceName: "homeNew"), for: .normal)
        
        self.searchBarHeight.constant = 56
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutSubviews()
        })
    }
    
    @IBAction func myMessagesClicked(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.takeToMessages()
            } else {
                self.takeToLogin()
            }
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        self.takeToInfo()
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        if AppDelegate.session.user != nil {
            takeToPostAdd()
        } else {
            takeToLogin()
        }
    }
    
    @IBAction func accountClicked(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.takeToAccount()
            } else {
                self.takeToLogin()
            }
        }
    }
    
    func searchKey() {
        self.view.addSubview(searchView)
        UIView.animate(withDuration: 0.4, animations: {
            self.searchView.frame.origin.y =  self.searchBar.frame.origin.y + self.searchBar.frame.height
        })
        
        self.filteredPosts.removeAll()
        
        var requestCounter = 2 {
            didSet {
                if requestCounter == 0 {
                    self.collectionView.reloadData()
                }
            }
        }
        
        let text = searchBar.text ?? ""
        databaseRef
            .child("ios_posts")
            .queryOrdered(byChild: "title")
            .queryStarting(atValue: text)
            .queryEnding(atValue: "\(text)\\uf8ff")
            .observe(.value, with: {(snapshot) in
                if snapshot.exists(){
                    for postData in snapshot.children.allObjects as! [DataSnapshot]   {
                        if let post = Post(snapshot: postData) {
                            self.filteredPosts.append(post)
                        }
                    }
                }
                
                requestCounter += -1
            })
        databaseRef
            .child("ios_posts")
            .queryOrdered(byChild: "keywords")
            .queryStarting(atValue: text)
            .queryEnding(atValue: "\(text)\\uf8ff")
            .observe(.value, with: {(snapshot) in
                if snapshot.exists(){
                    for postData in snapshot.children.allObjects as! [DataSnapshot]   {
                        if let post = Post(snapshot: postData) {
                            self.filteredPosts.append(post)
                        }
                    }
                }
                
                requestCounter += -1
            })
        self.view.endEditing(true)
    }
    
    func selectedPost(post: Post) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPostSegue" {
            guard let post = sender as? Post,
                let reviewPostVc = segue.destination as? ViewPostVC else {return}
            reviewPostVc.passPost = post            
        }
    }
}

extension HomeVC {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.4, animations: {
            self.searchView.frame.origin.y = UIScreen.main.bounds.height
        })
    }
}

// MARK: - UITableViewDataSource

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryForRow.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell") as? CollectionTableViewCell {
            let postsCollectionManager = PostsCollectionCollectionManager()
            postsCollectionManager.delegate = self
            if let category = categoryForRow[indexPath.section] {
                postsCollectionManager.posts = allPosts.filter { $0.category == category }
            } else {
                postsCollectionManager.posts = allPosts
            }
            cell.collectionManager = postsCollectionManager
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let category = categoryForRow[indexPath.section] {
            if allPosts.filter({ $0.category == category }).isEmpty {
                return 0
            }
        }
        return 165
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let category = categoryForRow[section] {
            return allPosts.filter({ $0.category == category }).isEmpty ? nil : category.rawValue.capitalized
        } else {
            return "All posts"
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionItemCell", for: indexPath) as! CollectionItemCell
        let sweet = filteredPosts[indexPath.item]
        cell.itemImageView.sd_setImage(with: sweet.logoUrl)
        cell.tag = indexPath.item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = filteredPosts[indexPath.item]
        performSegue(withIdentifier: "ViewPostSegue", sender: post)
    
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
//            let itemsPerRow: CGFloat = 2.08
//            let sectionInsets = UIEdgeInsets(top: 1, left: 1.0, bottom: 1, right: 1)
//            let paddingSpace = sectionInsets.top * (itemsPerRow + 1)
//            let availableWidth = collectionView.frame.width - paddingSpace
//            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: 180, height: 180)
            
        }  else {
            let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
            let itemsPerRow: CGFloat = 3.2
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView {
            let sectionInsets = UIEdgeInsets(top: 4, left: 2.0, bottom: 4, right: 2)
            return sectionInsets.left            } else {
            
            let sectionInsets = UIEdgeInsets(top: 0, left: 3.0, bottom: 0, right: 3)
            return sectionInsets.left
        }
    }
    
    func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
        
        if collectionView == self.collectionView {
            return 2
        } else {
            return 1
        }
    }
}

extension HomeVC: PostsCollectionCollectionManagerDelegate {
    func selectedPost(_ post: Post) {
        performSegue(withIdentifier: "ViewPostSegue", sender: post)
    }
}

