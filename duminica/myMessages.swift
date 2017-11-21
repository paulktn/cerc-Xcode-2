

import Foundation
import UIKit
import Firebase


class myMessagePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    var cellSelected : Int = 0
    var items = [Conversation]()
    
    
    var deleteString: String!
    
    var selectedUser: User?
    var linkPic: String!
    var facebookid: String!
    
  //  @IBOutlet weak var noMessages: UILabel!
    
    @IBOutlet weak var ttableView: UITableView!
    
    @IBOutlet var doublecheck: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!

    
    override func viewDidLoad() {
    super.viewDidLoad()
        fetchData()
     
    }
    
    
    @IBAction func back(_ sender: AnyObject) {
        
        pushTomainView()
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Homes") as! HomeView
        self.show(vc, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
            
           }
       
    }
    
    
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            self.deleteButton.alpha = 0
            return 1
        } else {
            self.deleteButton.alpha = 1
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TBCell
            // cell.clearCellData()
            
            cell.nameLabel.text = self.items[indexPath.row].user.name
        
            linkPic = self.items[indexPath.row].user.email
            facebookid = self.items[indexPath.row].user.id
        
            print(String(describing: self.facebookid!))
           
                    let removal: [Character] = [".", "#", "$", "@"]
                    
                    let unfilteredCharacters = linkPic.characters
                    
                    let filteredCharacters = unfilteredCharacters.filter { !removal.contains($0) }
                    
                    let filtered = String(filteredCharacters)
        
                    self.databaseRef.child("users").child("emailProfilePictures").child("\(filtered)").observe(.value, with: { (snapshot) in
                        if snapshot.exists(){
                         cell.profilePic.sd_setImage(with: URL(string: "\(snapshot.value! as! String)"))
                        } else {
                            self.databaseRef.child("users").child(self.facebookid).child("credentials").child("id").observe(.value, with: { (snapshot) in
                                if snapshot.exists() {
                            cell.profilePic.sd_setImage(with: URL(string: "https://graph.facebook.com/\(snapshot.value! as! String)/picture?type=small"))
                             
                                    print(self.facebookid)}}
                            )}})
          //cell.timeLabel.text
            
            
            
            
            let message = self.items[indexPath.row].lastMessage.content as! String
            cell.messageLabel.text = message
            
            let outFormatter = DateFormatter.init()
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
          
            outFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            outFormatter.dateStyle = .medium
            outFormatter.timeStyle = .short
            let date =  outFormatter.string(from: messageDate)
            
            cell.timeLabel.text! = date

            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                //   cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                //   cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                //     cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 15.0)
                
                // cell.messageLabel.textColor = GlobalVariables.purple
            }
            return cell
        }
    }
    @IBAction func deleteCo(_ sender: Any) {
         Conversation.eraseConversations()
        
    
        //self.pushTomainView()
    }
    
    @IBAction func presentDoublecheck(_ sender: Any) {
   
        self.view.addSubview(doublecheck)
        self.doublecheck.center = self.view.center
        
    }
    
    @IBAction func removeDoubleCheck(_ sender: Any) {
        self.doublecheck.removeFromSuperview()
      
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            
            
            
        
            
            self.performSegue(withIdentifier: "toChat", sender: self)
            
        }
    }
    
    
    func takeToLogin() {
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginActually
        self.show(loginVC, sender: nil)
    }
    
    
   

    
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.ttableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        break
                    }
                }
            }
        }}
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.ttableView.indexPathForSelectedRow {
            self.ttableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    
    
    
    
    
    
    
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }
    
    
    
}
