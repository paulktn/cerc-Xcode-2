//
//  chatVC.swift
//  GiveMain
//
//  Created by paul catana on 3/7/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

import Firebase


class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Properties
   
    
    @IBOutlet weak var chatWith: UILabel!
    @IBOutlet var inputText: IQTextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var items = [Message]()
    var currentUser: User?
   
    
     override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.delegate = self
       tableView.dataSource = self
      // tableView.estimatedRowHeight = 300
      tableView.rowHeight = UITableViewAutomaticDimension
      
    
        
      //  IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        
          
        
        inputText.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.cancelAction(_:)), doneAction: #selector(self.donebuttonSend))
       // let toolBar2 = UIToolbar()
        
    //    toolBar2.sizeToFit()
       // inputText.setCustomDoneTarget(self, action: #selector(self.donebuttonSend))
        
       
        //
       // inputText.placeholderText = "cancel"
        
       // inputText.inputAccessoryView = toolBar2

        
        self.fetchData()
    }
    
    func cancelAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    func doneClicked() {
        
        
    }
    
    func donebuttonSend() {
   
        if let text = self.inputText.text {
            if text.characters.count > 0 {
                self.composeMessage(content: self.inputText.text!)
                self.inputText.text = ""
                tableView.reloadData()
                
            }}
        self.view.endEditing(true)    }
    
    

    
    
    
    //Downloads messages
    func fetchData() {
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
            })
        Message.markMessagesRead(forUserID: self.currentUser!.id)
}
    
    func eraseMessages() {
        
        
    }
    
    //Hides current viewcontroller
    func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func composeMessage(content: Any)  {
        let message = Message.init(content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    
    func tableViewScrollToBottom() {
        if self.tableView.contentSize.height > self.tableView.frame.size.height
        {
            let offset:CGPoint = CGPoint(x: 0,y :self.tableView.contentSize.height-self.tableView.frame.size.height)
            self.tableView.setContentOffset(offset, animated: false)
        }
    }
    
  
    
    //MARK: NotificationCenter handlers
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
                    }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
       
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
                           cell.message.text = self.items[indexPath.row].content as? String
            
            
            return cell
            
            
            
            
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
           
                cell.message.text = self.items[indexPath.row].content as? String
            
            
         
            return cell
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputText.resignFirstResponder()
           }
    
  //  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  //      textField.resignFirstResponder()
 //       return true
  //  }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputText.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(self.cancelAction(_:)), doneAction: #selector(self.donebuttonSend))
        self.view.endEditing(true)
    }
    
    
    
    
    
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
      //  IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        
        
       
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Message.markMessagesRead(forUserID: self.currentUser!.id)
        self.view.endEditing(true)
        
    }
    
   }


extension UITableView
{
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}
