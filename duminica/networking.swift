//
//  NetworkingService.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/16/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import Foundation
import Firebase


struct NetworkingService {
    
    var databaseRef: DatabaseReference! {
        
        return Database.database().reference()
    }
    
    var storageRef: StorageReference! {
        
        return Storage.storage().reference()
    }
    
    
    
 


    
        

    

    
    
    func signIn(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has logged in successfully!")
                    
                    _ = UIApplication.shared.delegate as! AppDelegate
                    // appDel.takeToHome()
                    }} else {
                print(error!.localizedDescription) }})}
    
    func fetchAllPosts(completion: @escaping ([Post])->()){
        
        let postsRef = databaseRef.child("posts")
        postsRef.observe(.value, with: { (posts) in
            
            var resultArray = [Post]()
            for post in posts.children {
                
                let post = Post(snapshot: post as! DataSnapshot)
                resultArray.append(post)
            }
            completion(resultArray)

        }) { (error) in
            print(error.localizedDescription)
        }

    }
      
    
            
            
    
    
   
      
    
    func downloadImageFromFirebase(urlString: String, completion: @escaping (UIImage?)->()){
        
        let storageRef = Storage.storage().reference(forURL: urlString)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if let data = imageData {
                    completion(UIImage(data:data))
                    
                }
            }
        }

    
}
    
    func XXXXsavePostToDB(post: Post, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("posts").child((Auth.auth().currentUser!.uid))
            postRef.setValue(post.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
               "insert thank you page"
                completed()
            }
        }
        
    }
    
        func uploadImageToFirebasexxx(postId: String, imageData1:Data, imageData2:Data, imageData3:Data, completion: @escaping (URL)->()){
        
        
        
        
        
        
        
        
        let postImagePath1 = "postImages/\(postId)image1.jpg"
        let postImageRef1 = storageRef.child(postImagePath1)
        
        let postImagePath2 = "postImages/\(postId)image2.jpg"
        let postImageRef2 = storageRef.child(postImagePath2)
        
        
        let postImagePath3 = "postImages/\(postId)image3.jpg"
        let postImageRef3 = storageRef.child(postImagePath3)
        
        
        
        let postImageMetadata = StorageMetadata()
        postImageMetadata.contentType = "image/jpeg"
        
        
       
        
        switch  imageData3
        {
        case   imageData1:
        
         postImageRef1.putData(imageData1, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL1 = newPostImageMD?.downloadURL() {
                
                    completion(postImageURL1) }
            
                
                }
            
         }
            break;
        case imageData2:
            
        postImageRef2.putData(imageData2, metadata: postImageMetadata) { (newPostImageMD, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                if let postImageURL2 = newPostImageMD?.downloadURL() {
                    
                    completion(postImageURL2) }
                
                
            }
            
        };  break;
            
        case imageData3:
            
            postImageRef3.putData(imageData3, metadata: postImageMetadata) { (newPostImageMD, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    if let postImageURL3 = newPostImageMD?.downloadURL() {
                        
                        completion(postImageURL3) }
                    
                    
                }
            
            
            
            
            
            }; break;

        default: break;

}
    }}


    
