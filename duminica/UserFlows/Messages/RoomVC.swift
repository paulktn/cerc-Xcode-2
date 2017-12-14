//
//  RoomVC.swift
//  duminica
//
//  Created by Natali on 10.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RoomVC: UIViewController {

    var rooms: [ChatRoom] = []
    var chatLoaded: Bool!
    var i = 0
    var roomCount = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancellPressed)), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = "Chat Rooms"
        tableView.register(UINib.init(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "RoomCell")
        getChatRooms()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    @objc private func cancellPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func getChatRooms() {
        guard let id = AppDelegate.session.user?.id else {
            return
        }
        chatLoaded = false
        ActivityIndicator.shared.show(inView: view)
        let userRef = Database.database().reference().child("ios_users").child(id)
        let roomRef = Database.database().reference().child("ios_conversations")
        userRef.child("user_conversations").observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as?  Dictionary<String, Any> else {
                return
            }
            for (_, value) in data {
                self.i += 1
                self.roomCount = data.count
                guard let value = value as? String else {
                    return
                }
                roomRef.child(value).observe(.value, with: { (snapshot) in
                    self.rooms.append(ChatRoom.init(snapshot: snapshot, completion: {
                        if self.i == self.roomCount {
                            self.i = 0
                            self.roomCount = 0
                            self.tableView.reloadData()
                        }
                    })!)
                })
            }
            self.chatLoaded = true
            ActivityIndicator.shared.hideWithDelay()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatVC",
            let vc = segue.destination as? ChatVC,
            let room = sender as? ChatRoom {
            vc.post = room.post
            vc.roomId = room.id
        }
    }
    
}

extension RoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as? RoomCell else {
            return UITableViewCell()
        }
        cell.setUpCell(room: rooms[indexPath.row])
        i += 1
        if i == roomCount {
//            roomCount = 0
            i = 0
            rooms.removeAll()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoomCell else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showChatVC", sender: cell.room)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
