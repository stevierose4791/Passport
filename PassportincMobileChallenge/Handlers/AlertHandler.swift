//
//  AlertHandler.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/14/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit
import Firebase

class AlertHandler:NSObject {
    static let shared = AlertHandler()

    
    func userDataMissingAlert(vc:UIViewController){
        let alertController = UIAlertController(title: "Please Check", message: "name/age/gender", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let pc = ProfileController()
            let controllerNav = UINavigationController(rootViewController: pc)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = controllerNav
            
        }
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    func networkConnectionFailed(vc:UIViewController){
        let alertController = UIAlertController(title: "Please Check", message: "your connection", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
 
        }
        alertController.addAction(okAction)
       
        vc.present(alertController, animated: true, completion: nil)
    }

    func confirmProfleDeletion(vc:UIViewController, profile:Profile){
  
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure?", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let dbRef = Database.database().reference().child("profile")
            let ref = dbRef.child(profile.key)
            ref.setValue(nil)
            
            let pc = ProfileController()
            let controllerNav = UINavigationController(rootViewController: pc)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = controllerNav
           
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true, completion: nil)

    }
    
    

}
