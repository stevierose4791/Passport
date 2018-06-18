//
//  ProfileCell.swift
//  PassportincMobileChallenge
//
//  Created by Steven Roseman on 6/11/18.
//  Copyright © 2018 Steven Roseman. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    var profile: Profile? {
        didSet {

            self.profileImageView.loadImageUsingWithUrlString(urlString: (profile?.imageUrl)!)
            
            nameLabel.text = profile?.name
            ageLabel.text = profile?.age
            genderLabel.text = profile?.gender
            firstHobbyLabel.text = profile?.firstHobby
            secondHobbyLabel.text = profile?.secondHobby
        }
    }
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "defaultimg"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 0.27 * imageView.bounds.size.width
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Emily"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let ageLabel:UILabel = {
        let label = UILabel()
        label.text = "33"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel:UILabel = {
        let label = UILabel()
        label.text = "female"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstHobbyLabel:UILabel = {
        let label = UILabel()
        label.text = "Sports"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondHobbyLabel:UILabel = {
        let label = UILabel()
        label.text = "Coding"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func addSubViews(){
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(genderLabel)
        addSubview(firstHobbyLabel)
        addSubview(secondHobbyLabel)
    }
    
    func setup() {
        NSLayoutConstraint.activate([
            profileImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35),
            profileImageView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            profileImageView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -35),
            profileImageView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.trailingAnchor, constant:8),
            nameLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant:15),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.bottomAnchor),
            genderLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
            ageLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderLabel.safeAreaLayoutGuide.bottomAnchor),
            ageLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: profileImageView.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
            
            firstHobbyLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            firstHobbyLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            firstHobbyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            secondHobbyLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: firstHobbyLabel.safeAreaLayoutGuide.bottomAnchor),
            secondHobbyLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: genderLabel.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            secondHobbyLabel.heightAnchor.constraint(equalToConstant: 20),

        ])
        
    }
    
}
