//
//  DB.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/11/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage



class DB:NSObject{
    
    static var shared = DB()
    private var dbRef: DatabaseReference!
    private var url:String!
    var aprofile = [Profile]()

    var id:Int!
    
    
    override init() {
        self.dbRef = Database.database().reference()
    }
    
    func loadSavedProfiles(){
        
    }
    
    func addNewUserProfile(name:String, age:String, gender:String,firstHobby:String, secondHobby:String, id:Int){
        //check image not nil
        //check gender, name, age - not nil
        self.dbRef = Database.database().reference().child("profile")
        let key = dbRef.childByAutoId().key

        let profileData = ["name":name,
                           "age":age,
                           "firstHobby":firstHobby,
                           "secondHobby":secondHobby,
                           "gender": gender,
                           "id": id,
                           "key": key,
                           "imageUrl": self.url,
             
                           
            
        ] as [String : Any]
        
        self.dbRef.child(key).setValue(profileData)
    }
    
    func updateUserProfile(name:String, age:String, gender:String,firstHobby:String, secondHobby:String, id:Int, key:String, userImage:String){
        self.dbRef = Database.database().reference().child("profile")
        print(firstHobby)
        
        let profileData = ["name":name,
                           "age":age,
                           "firstHobby":firstHobby,
                           "secondHobby":secondHobby,
                           "gender": gender,
                           "id": id,
                           "key": key,
                           "imageUrl":userImage
            
            ] as [String : Any]
        
       // self.dbRef.setValue(profileData)
        self.dbRef.child(String(key)).setValue(profileData) { (error, ref) in
            if error != nil{
                guard let error = error else {
                    return
                }
                print(error)
                //alert error
                
            } else {
                let profile = Profile(name: name, gender: gender, age: age, id: id, firstHobby: firstHobby, secondHobby: secondHobby, key: key, imageUrl: userImage)
               let dc = DetailViewController()
                dc.profile = profile
                let controllerNav = UINavigationController(rootViewController: dc)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = controllerNav
                
            }
        }
    }
    

    
    func uploadImg(img:UIImage){
        //unique name for each image
        let imgName = NSUUID().uuidString

        guard let uploadData = img.jpeg(.lowest) else {
            return
        }
        //create storage reference
        let storage = Storage.storage()
        let storageRef = storage.reference().child("image/profile.jpg")
        
        let profileImage = storageRef.child("\(imgName).jpg")
        
        profileImage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if let err = error{
                print(err)
                return
            }
            profileImage.downloadURL(completion: { (url, error) in
                if let err = error {
                    print(err)
                    return
                }
                
                if let downloadURL = url?.absoluteString{
                    self.url = downloadURL
                }
                
            })
            
        }



    }
    
 

    
}



