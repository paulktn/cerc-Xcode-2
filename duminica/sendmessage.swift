//
//  sendmessage.swift
//  GiveMain
//
//  Created by paul catana on 3/4/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase


class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [Conversation]()
    var selectedUser: User?
    
    @IBOutlet weak var ttableView: UITableView!
    @IBOutlet weak var nnameLabel: UILabel!
    @IBOutlet weak var eemailLabel: UILabel!

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
        }
    }
    
    
    
    
    
    func customization() {
        
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                self.nnameLabel.text! = user.name
                self.eemailLabel.text! = user.email
                weakSelf?.nnameLabel.text! = user.name
                weakSelf?.eemailLabel.text! = user.email
                weakSelf = nil
                
                
            })
        }
    }
    
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TBCell
            cell.clearCellData()
            
            cell.nameLabel.text = self.items[indexPath.row].user.name
            
            let message = self.items[indexPath.row].lastMessage.content as! String
            cell.messageLabel.text = message
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                
                cell.messageLabel.textColor = UIColor.duminicaPurple
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        self.customization()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.ttableView.indexPathForSelectedRow {
            self.ttableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}

