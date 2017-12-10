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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancellPressed)), animated: true)
        navigationItem.title = "Chat Rooms"
    }
    
    @objc private func cancellPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
