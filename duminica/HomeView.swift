import UIKit
import Firebase
import CoreLocation
import Firebase
import Social

class HomeView: UIViewController, CLLocationManagerDelegate, PostDelegate, UITextFieldDelegate, ModernSearchBarDelegate {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var searchBar: ModernSearchBar!
    @IBOutlet weak var mainScrollView: UIScrollView!
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
    @IBOutlet weak var noItems: UILabel!
    @IBOutlet weak var homeDismissButton: UIButton!
    @IBOutlet weak var allItemsCollection: UICollectionView!
    @IBOutlet weak var clothingCollection: UICollectionView!
    @IBOutlet weak var furnitureCollection: UICollectionView!
    @IBOutlet weak var electronicsCollection: UICollectionView!
    @IBOutlet weak var appliancesCollection: UICollectionView!
    @IBOutlet weak var householdCollection: UICollectionView!
    @IBOutlet weak var sportingCollection: UICollectionView!
    @IBOutlet weak var toysCollection: UICollectionView!
    @IBOutlet weak var constructionCollection: UICollectionView!
    @IBOutlet weak var miscellaneousCollection: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    
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
    var filteredSweets = [Post] ()
    var searchToDisplay = [Post]()
    var allPostsToDisplay: [Post] = [Post] ()
    var clothingToDisplay = [Post] ()
    var furnitureToDisplay = [Post] ()
    var electronicsToDisplay = [Post] ()
    var appliancesToDisplay = [Post] ()
    var householdToDisplay = [Post] ()
    var sportingToDisplay = [Post]()
    var miscToDisplay = [Post]()
    var toysToDisplay = [Post]()
    var constructionToDisplay = [Post]()
    var postArray = [Post]()
    var sweets: [Post] = [Post]()
    var clothingPosts: [Post] = [Post]()
    var furniturePosts: [Post] = [Post]()
    var electronicsPosts: [Post] = [Post]()
    var appliancesPosts: [Post] = [Post]()
    var householdPosts: [Post] = [Post]()
    var allItemsPosts: [Post] = [Post]()
    var sportingPosts: [Post] = [Post]()
    var miscPosts: [Post] = [Post]()
    var constructionPosts: [Post] = [Post]()
    var toysPosts: [Post] = [Post]()
    var passPost: Post?
    var final = [String]()
    var postDelegate: PostDelegate?
    var canSendLocation = true
    var textGhost: String!
    var lati: Double!
    var longi: Double!
    var items = [Conversation]()
    var key: String!
    var blalocation: CLLocation!
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
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        allItemsCollection.delegate = self
        clothingCollection.delegate = self
        furnitureCollection.delegate = self
        electronicsCollection.delegate = self
        appliancesCollection.delegate = self
        householdCollection.delegate = self
        sportingCollection.delegate = self
        toysCollection.delegate = self
        constructionCollection.delegate = self
        miscellaneousCollection.delegate = self
        
        locationManager.delegate = self
        
        collectionView.dataSource = self
        allItemsCollection.dataSource = self
        clothingCollection.dataSource = self
        furnitureCollection.dataSource = self
        electronicsCollection.dataSource = self
        appliancesCollection.dataSource = self
        householdCollection.dataSource = self
        sportingCollection.dataSource = self
        toysCollection.dataSource = self
        constructionCollection.dataSource = self
        miscellaneousCollection.dataSource = self
        
        self.configureSearchBar()
        
        customizeHome()
        
        self.searchBar.alpha = 0
        self.noItems.alpha = 0
        fetchData()
        searchBar.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.searchKey))
        
        //getCollections()
        useCurentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cercleIn()
        customizeHome()
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
    
    func getCollections() {
        
        fetchAllPosts {(posts) in
            self.allItemsPosts = posts
            
            self.allPostsToDisplay = self.allItemsPosts.filter{
                $0.allPosts.contains("allPosts") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.allPostsToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.allItemsCollection.reloadData()

            self.clothingToDisplay = self.allItemsPosts.filter{
                $0.longit.isLessThanOrEqualTo((self.longi + 1)) && $0.postCategory.contains("clothing & accesories")
            }
            self.clothingToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.clothingCollection.reloadData()
            
            self.electronicsToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("electronics") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.electronicsToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.electronicsCollection.reloadData()

            self.furnitureToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("furniture") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.furnitureToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.furnitureCollection.reloadData()

            self.householdToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("household items") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.householdToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.householdCollection.reloadData()

            self.appliancesToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("appliances") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.appliancesToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.appliancesCollection.reloadData()

            self.toysToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("toys & games") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.toysToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.toysCollection.reloadData()

            self.constructionToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("home improvement") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.constructionToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.constructionCollection.reloadData()

            self.miscToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("miscellaneous") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.miscToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.miscellaneousCollection.reloadData()

            self.sportingToDisplay = self.allItemsPosts.filter{
                $0.postCategory.contains("sporting goods") && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.sportingToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            self.sportingCollection.reloadData()
            
        }
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
        
        homeDismissButton.alpha = 0
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
        let userLocation:CLLocation = locations[0] as CLLocation
        
        lati = userLocation.coordinate.latitude
        longi = userLocation.coordinate.longitude
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        self.getCollections()
        
        self.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func cercleIn() {
        UIView.animate(withDuration: 1,  animations: {
            self.appName.center = self.glass.center
        })}
    
    
    @IBAction func showMenu(_ sender: AnyObject) {
        if more.currentImage == #imageLiteral(resourceName: "Menu") {
            
            homeDismissButton.alpha = 1
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
            searchBar.alpha = 0
            add.alpha = 1
            self.more.setImage(#imageLiteral(resourceName: "Menu"), for: .normal)
            self.noItems.alpha = 0
            self.mainScrollView.alpha = 1
        }}
    
    
    
    
    
    
    @IBAction func removeMenu(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.y = (self.menuView.frame.origin.y - self.menuView.frame.height)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.menuBlur.frame.origin.y = (self.menuBlur.frame.origin.y - self.menuBlur.frame.height)
        })
        homeDismissButton.alpha = 0
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
        //menuBlur.alpha = 0
        homeDismissButton.alpha = 0
        add.alpha = 1
        
    }
    
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }}
    
    
    
    
    
    
    func takeToInfo() {
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "infoVC") as! OnboardingPresentationVC
        self.show(infoVC, sender: nil)
    }
    
    func takeToPostAdd(){
        let AddPostVC = self.storyboard?.instantiateViewController(withIdentifier: "Add Post") as! AddPost
        self.show(AddPostVC, sender: nil)
    }
    
    
    func takeToLogin() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginActually
        self.show(loginVC, sender: nil)
    }
    
    func takeToMessages() {
        let myMessagesVC = self.storyboard?.instantiateViewController(withIdentifier: "myMessagesVC") as! myMessagePage
        self.show(myMessagesVC, sender: nil)
    }
    
    
    func takeToAccount(){
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! account
        self.show(accountVC, sender: nil)
    }
    
    
    func doneClicked() {
        view.endEditing(true)
    }
    
    
    
    
    
    
    @IBAction func searchClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            // self.enterKeyword.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: 30)
        })
        self.mainScrollView.alpha = 0
        self.add.alpha = 0
        self.more.setImage(#imageLiteral(resourceName: "homeNew"), for: .normal)
        
        self.searchBar.alpha = 1
        
    }
    
    
    @IBAction func myMessagesClicked(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.takeToMessages()
            } else {
                self.takeToLogin()
            }}}
    
    
    @IBAction func infoClicked(_ sender: Any) {
        self.takeToInfo()
    }
    
    
    
    @IBAction func addClicked(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.takeToPostAdd()
            } else {
                self.takeToLogin()
            }}}
    
    
    @IBAction func accountClicked(_ sender: UIButton) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.takeToAccount()
            } else {
                self.takeToLogin()
            }}}
    
    
    
    
    
    
    func searchKey() {
        self.mainScrollView.alpha = 0
        self.view.addSubview(searchView)
        self.searchView.frame.origin.y =  100
        
        
        
        fetchAllPosts {(posts) in
            self.allItemsPosts = posts
            
            
            //print(String(describing: self.searchBar.text!))
            self.searchToDisplay = self.allItemsPosts.filter{
                $0.postTitle.contains(String(describing: self.searchBar.text!)) && $0.longit.isLessThanOrEqualTo((self.longi + 1))
            }
            self.searchToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.collectionView.reloadData()
        }
        
        self.view.endEditing(true)
    }
    
    func selectedPost(post: Post) {
        if  collectionView == self.allItemsCollection {
            self.performSegue(withIdentifier: "fromCustCell", sender: IndexPath.self)
        } else if collectionView == self.clothingCollection {
            self.performSegue(withIdentifier: "fromClothing", sender: IndexPath.self)
        }
        else if collectionView == self.furnitureCollection {
            self.performSegue(withIdentifier: "fromFurniture", sender: post)
        }
        else if collectionView == self.electronicsCollection {
            self.performSegue(withIdentifier: "fromElectronics", sender: post)
        }
        else if collectionView == self.appliancesCollection {
            self.performSegue(withIdentifier: "fromAppliances", sender: post)
        }
        else if collectionView == self.householdCollection {
            self.performSegue(withIdentifier: "fromHousehold", sender: post)
        }
        else if collectionView == self.sportingCollection {
            self.performSegue(withIdentifier: "fromSporting", sender: post)
        }else if collectionView == self.toysCollection {
            self.performSegue(withIdentifier: "fromToys", sender: post)
        }else if collectionView == self.constructionCollection {
            self.performSegue(withIdentifier: "fromConstruction", sender: post)
        }else if collectionView == self.miscellaneousCollection {
            self.performSegue(withIdentifier: "fromMisc", sender: post)
        }
        else {
            self.performSegue(withIdentifier: "fromSearch", sender: IndexPath.self)
        }}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromCustCell"{
            
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.allItemsCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = allPostsToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromClothing"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.clothingCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = clothingToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromFurniture"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.furnitureCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = furnitureToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromElectronics"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.electronicsCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = electronicsToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromAppliances"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.appliancesCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = appliancesToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromHousehold"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.householdCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = householdToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromSporting"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.sportingCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = sportingToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromToys"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.toysCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = toysToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromConstruction"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.constructionCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = constructionToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromMisc"{
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.miscellaneousCollection?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = miscToDisplay[indexPath.row]
            }}
        else if segue.identifier == "fromSearch" {
            let postDetailPage = segue.destination as? ViewPost
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPost = searchToDisplay[indexPath.row]
            }
        }
        
    }
    
}

