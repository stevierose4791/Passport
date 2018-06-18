//
//  ViewControllerHelper.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/17/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit

extension UIImageView{
    func loadImageUsingWithUrlString(urlString:String){
        guard let imageURL = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with:imageURL ) { (data, response, error) in
            if error != nil{
                if let err = error{
                    print(err)
                    return
                }
                
            }
            guard let imageData = data else{return}
            DispatchQueue.main.async {
               self.image = UIImage(data: imageData)
            }
            }.resume()
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

