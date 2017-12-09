//
//  report.swift
//  GiveMain
//
//  Created by paul catana on 6/16/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class report: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var passPostEdit: Post?
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        return Storage.storage().reference()
    }
    
    let reportItems = ["Prohibited item", "Nudity", "Eroticism", "Violence", "Duplicate listing", "Counterfeit items", "Inappropiate items title or Description", "Includes links Phone Numbers Emails", "Miscategorizied", "Description/Title/Image contains ads", "Description/Title/Image contains ads", "Image/Screenshot/Watermark", "Other"]
    var reason = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reportCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportItems.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        cell.textLabel?.text = reportItems[indexPath.row]
        cell.selectionStyle = .none
        // cell.accessoryType = UITableViewCellAccessoryType.checkmark
        cell.tintColor = UIColor.white
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        reason = (cell.textLabel?.text)!
        print(reason)
        print(passPostEdit!.city)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let header = cell 
        
        let traits = [UIFontWeightTrait : UIFontWeightThin] // UIFontWeightBold / UIFontWeightRegular
        var imgFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute: "Helvetica Neue"])
        imgFontDescriptor = imgFontDescriptor.addingAttributes([UIFontDescriptorTraitsAttribute:traits])
        
        header.textLabel?.font = UIFont(descriptor: imgFontDescriptor, size: 19)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.alpha = 1
        header.backgroundColor = UIColor.clear
        header.backgroundView?.alpha = 0.7
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textAlignment = .left
    }
    
    
    @IBAction func sendReport(_ sender: AnyObject) {
        flagIt(post: passPostEdit!, completed: {
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    func flagIt(post: Post, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("removals").child(reason).childByAutoId()
        postRef.setValue(post.serialized) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
