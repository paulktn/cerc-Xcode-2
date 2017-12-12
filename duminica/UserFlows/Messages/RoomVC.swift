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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancellPressed)), animated: true)
        navigationItem.title = "Chat Rooms"
        tableView.register(UINib.init(nibName: "RoomCell", bundle: nil), forCellReuseIdentifier: "RoomCell")
        getChatRooms()
    }
    
    
    @objc private func cancellPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func getChatRooms() {
        guard let id = AppDelegate.session.user?.id else {
            return
        }
        let userRef = Database.database().reference().child("ios_users").child(id)
        let roomRef = Database.database().reference().child("ios_conversations")
        userRef.child("ios_conversations").observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                return
            }
            for (key, _) in data {
                roomRef.child(key).observe(.value, with: { (snapshot) in
                    self.rooms.append(ChatRoom.init(snapshot: snapshot)!)
                })
            }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoomCell else {
            return
        }
        performSegue(withIdentifier: "showChatVC", sender: cell.room)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
