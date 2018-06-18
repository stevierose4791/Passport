//
//  SignUpController.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/17/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignUpController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubViews()
        setupLayout()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }


    func addSubViews(){
        view.addSubview(googleButton)
    }

    func setupLayout(){
    
        NSLayoutConstraint.activate([
        googleButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerXAnchor),
        googleButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerYAnchor),
        
            googleButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            googleButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        
        ])
        
        
    }
    
    let googleButton:GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
