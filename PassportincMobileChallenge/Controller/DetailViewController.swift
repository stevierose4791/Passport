//
//  DetailViewController.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/14/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit
import Firebase
class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
 

    var profile:Profile!
    var hobbies:[String]!
    var firstHobbyChosen:String!
    var secondHobbyChosen:String!
    var uid:String!
    private var dbRef: DatabaseReference!
    
    static var shared = DetailViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarItems()
        staticHobbyOptions()
        addSubViews()
        hideEditButtonAndPickerView()
        setupLayoutContraints()
        hideKeyboardWhenTappedAround()
        
       //add func to keep detailed data
        detailProfileData(profile: profile)
        
    }
    
    func staticHobbyOptions(){
         hobbies = ["Select hobby","coding","video games", "reading", "sports", "outdoor activities", "rock climbing", "travelling"]
    }
    func hideEditButtonAndPickerView() {
        firstHobbyPickerView.isHidden = true
        secondHobbyPickerView.isHidden = true
        updateProfileButton.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "defaultimg"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sherry"
        label.font = UIFont(name: "Helvetica neue", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel:UILabel = {
        let label = UILabel()
        label.text = "40"
        label.font = UIFont(name: "Helvetica neue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel:UILabel = {
        let label = UILabel()
        label.text = "female"
        label.font = UIFont(name: "Helvetica neue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstHobbyLabel:UILabel = {
        let label = UILabel()
        label.text = "outdoor activities"
        label.font = UIFont(name: "Helvetica neue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondHobbyLabel:UILabel = {
        let label = UILabel()
        label.text = "coding"
        label.font = UIFont(name: "Helvetica neue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var firstHobbyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.reloadAllComponents()
        
        return pickerView
    }()
    
    lazy var secondHobbyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.reloadAllComponents()
        
        return pickerView
    }()
    
    private let updateProfileButton:UIButton = {
        let button = UIButton()
        button.setTitle("Update Profile", for: .normal)
        button.addTarget(self, action: #selector(updateProfileButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteProfileButton:UIButton = {
        let button = UIButton()
        button.setTitle("Delete Profile", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func updateProfileButtonTapped(){
        DB.shared.updateUserProfile(name: profile.name, age: profile.age, gender: profile.gender, firstHobby: firstHobbyChosen, secondHobby: secondHobbyChosen, id: profile.id, key: profile.key, userImage: profile.imageUrl)
    }
    @objc func deleteButtonTapped(){
        //Confirm user wants to delete profile
        AlertHandler.shared.confirmProfleDeletion(vc: self, profile: profile)
    }

    private func navigationBarItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(backButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    
    func addSubViews(){
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        view.addSubview(genderLabel)
        view.addSubview(firstHobbyLabel)
        view.addSubview(secondHobbyLabel)
        view.addSubview(profileImageView)
        view.addSubview(deleteProfileButton)
        view.addSubview(firstHobbyPickerView)
        view.addSubview(secondHobbyPickerView)
        view.addSubview(updateProfileButton)
        
    }
    
    func setupLayoutContraints(){
        NSLayoutConstraint.activate([
            profileImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            
            nameLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.bottomAnchor, constant: 25),
            nameLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            genderLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.bottomAnchor, constant:15),
            genderLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            genderLabel.heightAnchor.constraint(equalToConstant: 30),
            
            ageLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderLabel.safeAreaLayoutGuide.bottomAnchor, constant:15),
            ageLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            ageLabel.heightAnchor.constraint(equalToConstant: 30),
            
            firstHobbyLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.bottomAnchor, constant: 85),
            firstHobbyLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 30),
            firstHobbyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            secondHobbyLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: firstHobbyLabel.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            secondHobbyLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 30),
            secondHobbyLabel.heightAnchor.constraint(equalToConstant: 40),
            
            firstHobbyPickerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: ageLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            firstHobbyPickerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            firstHobbyPickerView.heightAnchor.constraint(equalToConstant: 60),
            
            secondHobbyPickerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: firstHobbyPickerView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            secondHobbyPickerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            secondHobbyPickerView.heightAnchor.constraint(equalToConstant: 60),
            
            updateProfileButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: deleteProfileButton.safeAreaLayoutGuide.topAnchor, constant: -10),
            updateProfileButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            updateProfileButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            updateProfileButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            updateProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteProfileButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteProfileButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            deleteProfileButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            deleteProfileButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            deleteProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            
        ])
        
    }
    
    func detailProfileData(profile:Profile){
        nameLabel.text = profile.name
        ageLabel.text = profile.age
        genderLabel.text = profile.gender
        firstHobbyLabel.text = profile.firstHobby
        secondHobbyLabel.text = profile.secondHobby
        //run urlsession
        self.profileImageView.loadImageUsingWithUrlString(urlString: profile.imageUrl)
    }

    
    @objc func backButtonTapped(){
        
        let pc = ProfileController()
        let controllerNav = UINavigationController(rootViewController: pc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = controllerNav
    }
    
    @objc func editButtonTapped(){
        firstHobbyPickerView.isHidden = false
        secondHobbyPickerView.isHidden = false
        updateProfileButton.isHidden = false

    }
    
   

}
