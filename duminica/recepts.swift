//
//  recepts.swift
//  duminica
//
//  Created by paul catana on 8/28/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class recepts: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    @IBOutlet weak var receptRequest: UIButton!
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var backgroundBlur: UIView!
    
    @IBOutlet weak var ttableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet var receptInfoView: UIView!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var greetingText: UILabel!
   
    @IBOutlet weak var checkMark: UIImageView!
    
    @IBOutlet weak var confirmationLabel: UILabel!
    
    
   
    var itemNameForReceipt: String!
    var selectedUser: User?
    let currentUser = Auth.auth().currentUser!.uid
    var items = [PickedUp]()
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllReceivedPost()
        ttableView.delegate = self
        ttableView.dataSource = self
        greeting()
        backgroundBlur.alpha = 0
        disclaimerLabel.numberOfLines = 0
        greetingText.text! = "Hello "
        confirmationLabel.alpha = 0
        checkMark.alpha = 0
        
        
        }
    
    
    

    
    
    
    
    
    
    func greeting() {
        
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                self.nameField.text! = ("\(user.name)")
                
                self.greetingText.text! = "Hello \(user.name). You have two completed donations!"
                
                weakSelf?.nameField.text! = ("\(user.name)")
                
                self.emailField.text! = ("\(user.email)")
                 weakSelf?.emailField.text! = ("\(user.email)")
                weakSelf = nil
                print(user.name)
                
            })
        }}
    
    
    func fetchAllReceivedPost(completion: @escaping ([PickedUp])->()) {
        
        
        
        
        databaseRef.child("pickedup").child(self.currentUser).observe(.value, with: { (snapshot) in
            
            var ReceivedpostArray = [PickedUp]()
            for podddst in snapshot.children {
                
                let postObject = PickedUp(snapshot: podddst as! DataSnapshot)
                ReceivedpostArray.append(postObject)
                
            }
            self.items = ReceivedpostArray
            self.ttableView.reloadData()
        }) { (error:Error) in
            print(error.localizedDescription)
        }}
    
    private func fetchAllReceivedPost(){
        Auth.auth().addStateDidChangeListener { auth, user in
           
                self.fetchAllReceivedPost {(posts) in
                    self.items = posts
                    self.items.sort(by: { (post1, post2) -> Bool in
                        Int(post1.pickedDate) > Int(post2.pickedDate)
                    })
                    
                    self.ttableView.reloadData()
            }}}

    
    @IBAction func requestRecept(_ sender: Any) {
       
        let donor = nameField.text!
        let email = emailField.text!
        
    
        
        let requested = Recept(donorName: donor, receptNumber: "de", date: "date", description: "lk", values: "lk", emailForRecept: email)
        
        
        let postRef = databaseRef.child("ReceptRequests").child(currentUser).childByAutoId()
        postRef.setValue(requested.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.receptInfoView.removeFromSuperview()
               // self.backgroundBlur.alpha = 1
                self.confirmationLabel.alpha = 1
                self.checkMark.alpha = 1
                func delay(delay: Double, closure: @escaping () -> ()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        closure()
                    }}
                delay(delay: 3) {
                    self.backgroundBlur.alpha = 0
                    self.receptRequest.alpha = 1
                }
             
            }}}
    
    
    
    
    
    
    
    
    
    
  
    

    @IBAction func presentReceptView(_ sender: Any) {
       self.backgroundBlur.alpha = 1
        self.confirmationLabel.alpha = 0
        self.checkMark.alpha = 0
        self.view.addSubview(receptInfoView)
        self.receptInfoView.center = self.view.center
        self.receptRequest.alpha = 0
        
        
    }
    
    @IBAction func cancelRecept(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        backgroundBlur.alpha = 0
        self.receptRequest.alpha = 1
    }
    
    func request(post: PickedUp, completed: @escaping ()->Void){
        
           }
    
    @IBAction func backToAccount(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell")!
          
            self.receptRequest.alpha = 0
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! itemReceptCell
            // cell.clearCellData()
           
                      self.receptRequest.alpha = 1
            
            let item = items[indexPath.row]
            
            let outFormatter = DateFormatter.init()
        let messageDate = Date.init(timeIntervalSince1970: TimeInterval(item.pickedDate))
        outFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         
            outFormatter.dateStyle = .medium
            outFormatter.timeStyle = .short
            let date =  outFormatter.string(from: messageDate)
            
            cell.itemName.text! = item.itemName
            itemNameForReceipt = item.itemName
            cell.pickedUpDate.text! = "Donation completed on \(date)."
            
            cell.dryer = [Int](20...90)
            
            
            cell.picker.reloadAllComponents();
            return cell
        }
        
    }

    

    
    
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
              
               self.ttableView.reloadData()
    }




}



extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}


