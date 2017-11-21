//
//  extensionHome.swift
//  GiveMain
//
//  Created by paul catana on 5/8/17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit
import Firebase
import GeoFire


extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func fetchAllPosts(completion: @escaping ([Post])->()) {
              var allArray = [Post]()
        
        print("\(lati)")
        let finalRef = self.databaseRef.child("posts").queryOrdered(byChild: "latit").queryStarting(atValue: lati - 1).queryEnding(atValue: (lati + 1))
        print(lati)
        finalRef.observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                            
                            for posts in snapshot.children.allObjects as! [DataSnapshot]   {
                                let householdObject = Post(snapshot: posts )
                                allArray.append(householdObject)
                                
                                completion(allArray)
                                self.allItemsPosts = allArray
                                
                }}})}
    
    func fetchSearchPosts(completion: @escaping ([Post])->()) {
        var allArray = [Post]()
        
        print("\(lati)")
        let finalRef = self.databaseRef.child("posts").queryOrdered(byChild: "latit").queryStarting(atValue: lati - 1).queryEnding(atValue: (lati + 1))
        print(lati)
        finalRef.observe(.value, with: { (snapshot) in
            
            if snapshot.exists(){
                
                
                for posts in snapshot.children.allObjects as! [DataSnapshot]   {
                    let householdObject = Post(snapshot: posts )
                    allArray.append(householdObject)
                    
                    completion(allArray)
                    self.allItemsPosts = allArray
                    
                }}})}


    
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.allItemsCollection {
            return allPostsToDisplay.count }
        else if collectionView == self.furnitureCollection {
            return furnitureToDisplay.count
        } else if collectionView == self.electronicsCollection {
            
                return electronicsToDisplay.count
        } else if collectionView == self.appliancesCollection {
            
            return appliancesToDisplay.count
        } else if collectionView == self.householdCollection {
            return householdToDisplay.count
        }
        else if collectionView == self.sportingCollection {
            return sportingToDisplay.count
        }
        else if collectionView == self.toysCollection {
            return toysToDisplay.count
        }
        else if collectionView == self.constructionCollection {
            return constructionToDisplay.count
        }
        else if collectionView == self.clothingCollection {
            return clothingToDisplay.count
        }
        else if collectionView == self.miscellaneousCollection {
            return miscToDisplay.count
        }
            
            
        else {
            return searchToDisplay.count
        
        }}
    
    
    
    
    
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clothingCollection {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
        let sweet = clothingToDisplay[indexPath.item]
        cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
        
        cell.tag = indexPath.item
        return cell
            
            
            
        }
        else if collectionView == self.allItemsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = allPostsToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
            
            
        }
        else if collectionView == self.furnitureCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = furnitureToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
        }
        else if collectionView == self.electronicsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = electronicsToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
        }
        
     else if collectionView == self.appliancesCollection {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
    let sweet = appliancesToDisplay[indexPath.item]
    cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
    
    cell.tag = indexPath.item
            return cell
        }
        
            
          else  if collectionView == self.householdCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = householdToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
        }
    
        else  if collectionView == self.miscellaneousCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = miscToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
            
        }
        else  if collectionView == self.sportingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = sportingToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
            
        }
            
        else  if collectionView == self.toysCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = toysToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
            
        }
            
        else  if collectionView == self.constructionCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = constructionToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
            
            
        }
    
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custCell", for: indexPath) as! custCell
            let sweet = searchToDisplay[indexPath.item]
            cell.imageCell.sd_setImage(with: URL(string: sweet.postThumbURL))
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
            
            cell.tag = indexPath.item
            return cell
    
        }}
    
    
    
    
    
    
   
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.collectionView {
        postDelegate?.selectedPost(post: self.searchToDisplay[indexPath.item])
        self.passPost = self.searchToDisplay[indexPath.item]
        
    } else if collectionView == self.allItemsCollection {
        postDelegate?.selectedPost(post: self.allPostsToDisplay[indexPath.item])
       self.passPost = self.allPostsToDisplay[indexPath.item]
        
    } else if collectionView == self.clothingCollection {
        postDelegate?.selectedPost(post: self.clothingToDisplay[indexPath.item])
       self.passPost = self.clothingToDisplay[indexPath.item]
        
    } else if collectionView == self.furnitureCollection {
        postDelegate?.selectedPost(post: self.furnitureToDisplay[indexPath.item])
       self.passPost = self.furnitureToDisplay[indexPath.item]
        
    } else if collectionView == self.electronicsCollection {
        postDelegate?.selectedPost(post: self.electronicsToDisplay[indexPath.item])
       self.passPost = self.electronicsToDisplay[indexPath.item]
        
    } else if collectionView == self.appliancesCollection {
        postDelegate?.selectedPost(post: self.appliancesToDisplay[indexPath.item])
       self.passPost = self.appliancesToDisplay[indexPath.item]
        
    } else if collectionView == self.householdCollection {
        postDelegate?.selectedPost(post: self.householdToDisplay[indexPath.item])
      self.passPost = self.householdToDisplay[indexPath.item]
        
    } else if collectionView == self.sportingCollection {
        postDelegate?.selectedPost(post: self.sportingToDisplay[indexPath.item])
       self.passPost = self.sportingToDisplay[indexPath.item]
        
    } else if collectionView == self.toysCollection {
        postDelegate?.selectedPost(post: self.toysToDisplay[indexPath.item])
        self.passPost = self.toysToDisplay[indexPath.item]
        
    } else if collectionView == self.constructionCollection {
        postDelegate?.selectedPost(post: self.constructionToDisplay[indexPath.item])
        self.passPost = self.constructionToDisplay[indexPath.item]
    } else {
    
    postDelegate?.selectedPost(post: self.miscToDisplay[indexPath.item])
       self.passPost = self.miscToDisplay[indexPath.item]
    }}}







extension HomeView: UICollectionViewDelegateFlowLayout {

 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
           
             let itemsPerRow: CGFloat = 2.08
            let sectionInsets = UIEdgeInsets(top: 1, left: 1.0, bottom: 1, right: 1)
            let paddingSpace = sectionInsets.top * (itemsPerRow + 1)
             let availableWidth = collectionView.frame.width - paddingSpace
           let widthPerItem = availableWidth / itemsPerRow
           return CGSize(width: widthPerItem, height: widthPerItem)

        }  else
        
        {   let sectionInsets = UIEdgeInsets(top: 0, left: 1.0, bottom: 0, right: 1)
            let itemsPerRow: CGFloat = 3.2
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
    
        
        
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            
            
            
            let sectionInsets = UIEdgeInsets(top: 1, left: 1.0, bottom: 1, right: 1)
            return sectionInsets
            
            
            
    }
        
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            if collectionView == self.collectionView {
                let sectionInsets = UIEdgeInsets(top: 4, left: 2.0, bottom: 4, right: 2)
                return sectionInsets.left            } else {
          
             let sectionInsets = UIEdgeInsets(top: 0, left: 3.0, bottom: 0, right: 3)
                       return sectionInsets.left
            }}
    func maximumNumberOfColumns(for collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int {
        
        if collectionView == self.collectionView {
        let numColumns: Int = Int(2.0)
        return numColumns
        } else {
           return 1
        }
        
    }
    
}



