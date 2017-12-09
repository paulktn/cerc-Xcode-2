


import Foundation
import UIKit
import Firebase
import Photos
import SDWebImage

class AccountVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var selectedUser: User?
    
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var editProfilePic: RoundedImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet var manageItemsView: UIView!
    @IBOutlet var receivedItems: UIView!
    @IBOutlet var wishlist: UIView!
    @IBOutlet var picturesView: UIViewX3!
    @IBOutlet weak var emailAdresButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var collectionPicturesProfile: UICollectionView!
    
    @IBOutlet weak var nameField: IQTextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var picSwitch: UISwitch!
    @IBOutlet weak var switchEmailReminders: UISwitch!
    @IBOutlet weak var switchEmailMessages: UISwitch!
    @IBOutlet weak var switchPushMessages: UISwitch!
    @IBOutlet weak var switchPushItems: UISwitch!
    @IBOutlet weak var receiptsIcon: UIImageView!
    @IBOutlet weak var myPostingsIcon: UIImageView!
    @IBOutlet weak var receivedIcon: UIImageView!
    @IBOutlet weak var savedIcon: UIImageView!
    
    private enum OpenedOption {
        case myPostings
        case receivedItems
        case saved
        case settings
        case none
    }
    
    private var currentOption: OpenedOption = .none
    
    var adresaDeSchimbat: String!
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    @IBOutlet weak var nnameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wishCollectionView: UICollectionView!
    @IBOutlet weak var receivedCollectionView: UICollectionView!
    
    
    //  MARK: - Collection View Height
    
    @IBOutlet weak var myPostingsHeight: NSLayoutConstraint!
    @IBOutlet weak var receivedItemsHeight: NSLayoutConstraint!
    @IBOutlet weak var savedItemsHeight: NSLayoutConstraint!
    
    
    var sweets: [Post] = [Post]()
    var Wishsweets: [Post] = [Post]()
    var Receivedsweets: [PickedUp] = [PickedUp]()
    var selectedPost1: Post?
    var poza: String!
    var link: String!
    var nameLink: String!
    var postDelegate: PostDelegate?
    
    var cellSelected : Int = 0
    
    //  MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manageItemsView.alpha = 0
        receivedItems.alpha = 0
        wishlist.alpha = 0
        settingsView.alpha = 0
        
        collectionPicturesProfile.delegate = self
        collectionPicturesProfile.dataSource = self
        collectionView.reloadData()
        customization()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchAllPost()
        fetchAllWishPost()
        fetchAllReceivedPost()
        grabPhotos()
        
        wishCollectionView.delegate = self
        wishCollectionView.dataSource = self
        getURL()
        getEmail()
        
        nameField.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.doneClicked), doneAction: #selector(self.changeNameAction))
        nameField.alpha = 0
    }
    
    //  MARK: - IBAction
    
    @IBAction func animateSettings(_ sender: Any) {
        selectOption(.settings)
    }
    
    @IBAction func emailRemainders(_ sender: Any) {
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
                    }
                }
            }
        }
    }
    
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
                    }
                }
            }
        }
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
                    }
                }
            }
        }
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
                    }
                }
            }
        }
    }
    
    @IBAction func presentPicView(_ sender: Any) {
        self.view.addSubview(picturesView)
        self.picturesView.center = self.view.center
    }
    
    @IBAction func changeName(_ sender: Any) {
        self.nameField.alpha = 1
        self.nameButton.alpha = 0
    }
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func presentWishlist(_ sender: Any) {
        selectOption(.saved)
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        
        User.logOutUser { (status) in
            if status == true {
                self.pushTomainView()
            }
        }
    }
    
    @IBAction func presentManage(_ sender: AnyObject) {
        selectOption(.myPostings)
    }
    
    @IBAction func presentReceived(_ sender: Any) {
        selectOption(.receivedItems)
    }
    
    @IBAction func back(_ sender: AnyObject) {
        pushTomainView()
    }
    
    //  MARK: - Private
    
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
        case .myPostings:
            myPostingsHeight.constant = 139.0
            collectionView.alpha = 1
        case .receivedItems:
            receivedItemsHeight.constant = 139.0
            receivedCollectionView.alpha = 1
        case .saved:
            savedItemsHeight.constant = 139.0
            wishCollectionView.alpha = 1
        case .settings:
            settingsView.alpha = 1
        case .none:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        currentOption = newOption
    }
    
    private func closeAllCollections() {
        savedItemsHeight.constant = 0
        myPostingsHeight.constant = 0
        receivedItemsHeight.constant = 0
        collectionView.alpha = 0
        wishCollectionView.alpha = 0
        receivedCollectionView.alpha = 0
        
        settingsView.alpha = 0
    }
    
    func doneClicked() {
        view.endEditing(true)
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
            self.collectionPicturesProfile?.reloadData()
        }
    }
    
    func customization() {
        if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(currentUser).child("credentials").child("name").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.nameButton.setTitle("\(snapshot.value!)", for: .normal)
                    self.nnameLabel.text! = snapshot.value! as! String
                 
                    
                }
            })
        }
        else {
            takeToLogin()
        }
    }
    
    func getEmail() {
        if let currentUser = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(currentUser).child("credentials").child("email").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.emailAdresButton.setTitle("\(snapshot.value!)", for: .normal)
                    self.adresaDeSchimbat = snapshot.value! as! String
                    // print(snapshot.value!)
                }
            })
        }
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.profilePic.image = image
        self.editProfilePic.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func outPictures() {
        
        let image1 = editProfilePic.image
        let imageData1 = UIImageJPEGRepresentation(image1!, CGFloat(0.35))
        uploadImageToFirebase(imageData1: imageData1!, completion: { (url) in
        })
        self.picturesView.removeFromSuperview()
        self.button1.setTitle("", for: .normal) }
    
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
                    let unfilteredCharacters = self.adresaDeSchimbat
                    let filteredCharacters = unfilteredCharacters?.filter { !removal.contains($0) }
                    let filtered = String(describing: filteredCharacters)
                    self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").setValue(self.poza)
                    print(self.poza)
                    self.button1.setTitle("", for: .normal)
                    completion(postImageURL1)
                }
            }
        }
    }
    
    func getURL() {
        let currentUser = Auth.auth().currentUser!.uid
        databaseRef.child("users").child(currentUser).child("credentials").child("id").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.profilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                self.editProfilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                print(snapshot.value!)
                
            }   else
                
            {
                if let id = Auth.auth().currentUser?.uid {
                    User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                        let removal: [Character] = [".", "#", "$", "@"]
                        
                        let unfilteredCharacters = ("\(user.email)")
                        
                        let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                        
                        let filtered = String(filteredCharacters)
                        weakSelf?.link = ("\(user.email)")
                        self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").observe(.value, with: { (snapshot) in
                            if snapshot.exists(){
                                self.profilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
                                self.editProfilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
                            }
                        })
                    })
                }
            }
        })
    }
    
    
    func fetchAllPost(completion: @escaping ([Post])->()) {
        
        let currentUser = Auth.auth().currentUser!.uid
        
        databaseRef.child("posts").queryOrdered(byChild: "userId").queryEqual(toValue: currentUser).observe(.value, with: { (snapshot) in
            
            var postArray = [Post]()
            for podddst in snapshot.children {
                
                let postObject = Post(snapshot: podddst as! DataSnapshot)
                postArray.append(postObject)
                
            }
            self.sweets = postArray
            self.collectionView.reloadData()
            }) { (error:Error) in
            print(error.localizedDescription)
        }
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

    private func fetchAllPost(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
        self.fetchAllPost {(posts) in
            self.sweets = posts
            self.sweets.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.collectionView.reloadData()
                }
            }  else {
                self.takeToLogin()
            }
        }
    }
    
    func fetchAllWishPost(completion: @escaping ([Post])->()) {
        let currentUser = Auth.auth().currentUser!.uid
        databaseRef.child("wishlist").child(currentUser).observe(.value, with: { (snapshot) in
            
            var WishpostArray = [Post]()
            for podst in snapshot.children {
                
                let WishpostObject = Post(snapshot: podst as! DataSnapshot)
                WishpostArray.append(WishpostObject)
                
            }
            self.Wishsweets = WishpostArray
            self.wishCollectionView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.wishlist.alpha = 0
        self.receivedItems.alpha = 0
        self.manageItemsView.alpha = 0
    }
    
    private func fetchAllWishPost(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                
                self.fetchAllWishPost {(Wishposts) in
                    self.Wishsweets = Wishposts
                    self.Wishsweets.sort(by: { (post1, post2) -> Bool in
                        Int(post1.postDate) > Int(post2.postDate)
                    })
                    
                    self.wishCollectionView.reloadData()
                }}  else {
                self.takeToLogin()
            }
        }
    }
    
    func fetchAllReceivedPost(completion: @escaping ([PickedUp])->()) {

        let currentUser = Auth.auth().currentUser!.uid
        
        databaseRef.child("pickedup").child(currentUser).observe(.value, with: { (snapshot) in
            
            var ReceivedpostArray = [PickedUp]()
            for podddst in snapshot.children {
                
                let postObject = PickedUp(snapshot: podddst as! DataSnapshot)
                ReceivedpostArray.append(postObject)
                
            }
            self.Receivedsweets = ReceivedpostArray
            self.receivedCollectionView.reloadData()
        }) { (error:Error) in
            print(error.localizedDescription)
        }
    }
  
    private func fetchAllReceivedPost(){
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.fetchAllReceivedPost {(posts) in
                    self.Receivedsweets = posts
                    self.Receivedsweets.sort(by: { (post1, post2) -> Bool in
                        Int(post1.pickedDate) > Int(post2.pickedDate)
                    })
                    
                    self.receivedCollectionView.reloadData()
                }
            }  else {
                self.takeToLogin()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == self.collectionView {
        
        return sweets.count
        } else if collectionView == self.receivedCollectionView {
            return Receivedsweets.count
        } else if collectionView == self.collectionPicturesProfile {
            return imageArray.count
        } else {
             return Wishsweets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCust", for: indexPath) as! accountCust
        
        let sweet = sweets[indexPath.row]
        
      cell.imageCell.sd_setImage(with: URL(string: sweet.postImageURL1))
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(sweet.postDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            cell.dateCell.text = "posted now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute == 0 {
            cell.dateCell.text = "posted \(differenceOfDate.second!)seconds ago"
            }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            cell.dateCell.text = "posted \(differenceOfDate.minute!)mins. ago"
            }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            cell.dateCell.text = "posted \(differenceOfDate.hour!)hrs. ago"
            }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            cell.dateCell.text = "posted \(differenceOfDate.day!)days ago"
            }else if differenceOfDate.weekOfMonth! > 0 {
            cell.dateCell.text = "posted \(differenceOfDate.weekOfMonth!)weeks ago"
            }
      //  cell.configureCell(post: self.sweets[indexPath.item])
    cell.tag = indexPath.item
    return cell
        } else if collectionView == self.receivedCollectionView {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCust", for: indexPath) as! accountCust
            let Receivedsweet = Receivedsweets[indexPath.row]
            
            
            cell.imageCell.sd_setImage(with: URL(string: Receivedsweet.postImageURL1))
          //  cell.configureCell(post: self.Receivedsweets[indexPath.item])
            cell.tag = indexPath.item
             return cell
            
        } else if collectionView == self.collectionPicturesProfile {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
            let Cam = cell.viewWithTag(1) as! UIImageView
            
            Cam.image = imageArray[indexPath.row]
         
            return cell
        }
            
            
        else {
             let Wishcell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCust", for: indexPath) as! accountCust
        
        let Wishsweet = Wishsweets[indexPath.row]
        
        Wishcell.imageCell.sd_setImage(with: URL(string: Wishsweet.postImageURL1))
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(Wishsweet.postDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            Wishcell.dateCell.text = "posted now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute == 0 {
            Wishcell.dateCell.text = "posted \(differenceOfDate.second!)seconds ago"
            }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            Wishcell.dateCell.text = "posted \(differenceOfDate.minute!)mins. ago"
            }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            Wishcell.dateCell.text = "posted \(differenceOfDate.hour!)hrs. ago"
            }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            Wishcell.dateCell.text = "posted \(differenceOfDate.day!)days ago"
            }else if differenceOfDate.weekOfMonth! > 0 {
            Wishcell.dateCell.text = "posted \(differenceOfDate.weekOfMonth!)weeks ago"
            
        }
        Wishcell.configureCell(post: self.Wishsweets[indexPath.item])
        Wishcell.tag = indexPath.item
        return Wishcell
            
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
        
        
        postDelegate?.selectedPost(post: self.sweets[indexPath.item])
        self.selectedPost1 = self.sweets[indexPath.item]
        } else if collectionView == self.wishCollectionView {
           let Wishsweet = Wishsweets[indexPath.row]
            
            let currentUser = Auth.auth().currentUser!.uid
            let fromUser = Wishsweet.userId
            let itemValue =  "70"
            let pickedDate =  NSDate().timeIntervalSince1970 as NSNumber
            let itemName = Wishsweet.postTitle
            let picture = Wishsweet.postImageURL1
            let postId = Wishsweet.postId
            
            let pickedUpItem = PickedUp(byUser: currentUser, fromUser: fromUser, itemValue: itemValue, pickedDate: pickedDate, itemName: itemName,  postImageURL1: picture, postId: postId)
            
            
            let postRef = databaseRef.child("pickedup").child(currentUser).child(Wishsweet.postId)
            postRef.setValue(pickedUpItem.toAnyObject()) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else if collectionView == self.collectionPicturesProfile {
            if collectionView.cellForItem(at: indexPath) != nil {
                
                self.profilePic.image = self.imageArray[indexPath.item]
                self.editProfilePic.image = self.imageArray[indexPath.item]
                self.outPictures()
                
            }
        } else if collectionView == self.wishCollectionView {
            
        }
    }
    
    @IBAction func markAsPicked(_ sender: Any) {
        
    }
    
    @IBAction func viewItem(_ sender: Any) {
        
    }
    
    func selectedPost(post: Post) {
        self.performSegue(withIdentifier: "ToEdit", sender: IndexPath.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEdit" {
            
            
            let postDetailPage = segue.destination as? EditPost
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell) {
                postDetailPage?.passPostEdit = sweets[indexPath.row]
            }
        }
            
        else if segue.identifier == "toChat" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeVC
        self.show(vc, sender: nil)
    }
}

extension AccountVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
        let itemsPerRow: CGFloat = 2.8
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        }
    
        func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
            
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
        return sectionInsets.left
    }}
    
