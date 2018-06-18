//
//  Profile.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/11/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import Foundation
import UIKit
class Profile{
    var name:String
    var gender:String
    var age:String
    var id:Int
    //var profileImg: UIImage
    var firstHobby:String
    var secondHobby:String
    var key:String
    var imageUrl: String
    
    init(name:String, gender:String, age:String, id:Int, firstHobby:String, secondHobby:String, key:String, imageUrl:String) {
        self.name = name
        self.gender = gender
        self.age = age
        self.id = id
        //self.profileImg = profileImg
        self.firstHobby = firstHobby
        self.secondHobby = secondHobby
        self.key = key
        self.imageUrl = imageUrl

    }
    
}


