//
//  Clothing & Accesories.swift
//  GiveMain
//
//  Created by paul catana on 3/26/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GeoFire
import SDWebImage



class Clothing : UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate  {
    
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5)
    fileprivate let itemsPerRow: CGFloat = 3.1
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    var HomeVC: HomeVC!
    
    var sweets: [Post] = [Post]()
    
    var selectedPost1: Post?
    var postDelegate: PostDelegate?
    
    var filteredSweets = [Post] ()
    var sweetToDisplay = [Post] ()
    var nearbyUsers = [String] ()
    var locationManager = CLLocationManager()
    var canSendLocation = true
    let geoFireRef = Database.database().reference().child("postLocations")
    let geoFire = GeoFire(firebaseRef: Database.database().reference().child("postLocations"))
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    func configureTableCell() {
        setCollectionViewDataSourceDelegate(delegate: self, dataSource: self)
        self.locationManager.delegate = self
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
    
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func findLocal() {
        self.canSendLocation = true
        
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let circleQuery = geoFire!.query(at: userLocation, withRadius:200)
        self.stopUpdatingLocation()
        
        circleQuery!.observe(.keyEntered, with: { (key, location) in
            if !self.nearbyUsers.contains(key!) {
                self.nearbyUsers.append(key!)}
            
        })
        circleQuery?.observeReady({
            self.fetchAllPost {(posts) in
                self.sweets = posts
                
                self.sweetToDisplay = self.sweets.filter{
                    $0.category == .clothingAndAccesories
                }
                self.collectionView.reloadData()
            }})}
    
    
    
    
    
    internal func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate, S: UICollectionViewDataSource>(delegate: D, dataSource: S) {
        self.locationManager.delegate = self
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let myCollectionView = UICollectionView(frame: self.collectionView.bounds, collectionViewLayout: collectionViewFlowLayout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        collectionView.reloadData()
        fetchAllPost()
        findLocal()
    }
    
    
    func fetchAllPost(completion: @escaping ([Post])->()) {
        
        var postArray = [Post]()
        postArray.removeAll()
        
        for postari in self.nearbyUsers {
            let postsRef = databaseRef.child("posts").queryOrdered(byChild: "postId").queryEqual(toValue: "\(postari)")
            postsRef.observe(.value, with: { (snapshot) in
                
                
                for podddst in snapshot.children {
                    
                    let postObject = Post(snapshot: podddst as! DataSnapshot)
                    postArray.append(postObject)
                }
                completion(postArray)
                self.collectionView.reloadData()
            }) { (error:Error) in
                print(error.localizedDescription)
            }}}
    
    
    
    
    
    
    private func fetchAllPost(){
        fetchAllPost {(posts) in
            self.sweets = posts
            self.sweetToDisplay.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sweetToDisplay.count
    }
    
    
    
    
    
    
    
    
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
        
        
        let sweet = sweetToDisplay[indexPath.row]
        
        // cell.titleCell.text = sweet.city
        
        cell.imageCell.sd_setImage(with: URL(string: sweet.postImageURL1))
        
        
        
        
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(sweet.postDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            cell.dateCell.text = "now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute == 0 {
            cell.dateCell.text = "\(differenceOfDate.second!) seconds"
            
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            cell.dateCell.text = "\(differenceOfDate.minute!) minutes"
            
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            cell.dateCell.text = "\(differenceOfDate.hour!) hours"
            
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            cell.dateCell.text = "\(differenceOfDate.day!) days"
            
        }else if differenceOfDate.weekOfMonth! > 0 {
            cell.dateCell.text = "\(differenceOfDate.weekOfMonth!) weeks"
            
        }
        cell.configureCell(post: self.sweets[indexPath.item])
        cell.tag = indexPath.item
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        postDelegate?.selectedPost(post: self.sweetToDisplay[indexPath.item])
        
        
        self.selectedPost1 = self.sweetToDisplay[indexPath.item]
    }
}

extension Clothing : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    
}
