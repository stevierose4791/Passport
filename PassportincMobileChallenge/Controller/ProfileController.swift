//
//  ProfileController.swift
//  PassportincMobileChallenge


import UIKit
import Firebase


class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    var ages:[String]!
    var sortingByMale = [String]()
    var sortingByFemale = [String]()
    var aprofile:[Profile]!
    var hobbies:[String]!
    var sortOptions:[String]!
    var buttons = [UIButton]()
    let cell = "cell"
    var genderChosen:String!
    var maleChosen:String!
    var userImg:UIImage!
    var firstHobbyChosen:String!
    var secondHobbyChosen:String!
    var pickerViewOptionChose:String!
    var id:Int!
    var uid:String!
    private var dbRef: DatabaseReference!
    static var shared = ProfileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        
        //load all saved profiles
        //initial run pickerViewOptionChose is set to Empty
        pickerViewOptionChose = ""
        loadProfiles(withOptionChosen: pickerViewOptionChose)

        //hobby array initialized
        //sort options array initialized
        loadPickerViewData()
        
        addSubViews()
        setupLayout()
        navigationBarItems()
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            AlertHandler.shared.networkConnectionFailed(vc:self)
            return
            //view.backgroundColor = .red
        case .wifi:
            print("wifi exist")
            //view.backgroundColor = .green
        case .wwan:
            print("wwan")
            //view.backgroundColor = .yellow
        }
    
    }
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    lazy var profileTableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier:cell)
        tableView.bounces = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var filterPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.reloadAllComponents()
        
        return pickerView
    }()
    
    //overlay view
    //overlay controllers
    var overlayView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var ageTF:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 5
        tf.placeholder = "age"
        tf.keyboardType = .namePhonePad
        tf.returnKeyType = .next
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var nameTF:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 5
        tf.placeholder = "name"
        tf.keyboardType = .namePhonePad
        tf.returnKeyType = .next
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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

    
    var userImgButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "defaultimg"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userImgButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica neue", size: 14)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var genderSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select one"
        label.textColor = .black
        label.font = UIFont(name: "Helvetica neue", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var maleLabel: UILabel = {
        let label = UILabel()
        label.text = "male"
        label.textColor = .black
        label.font = UIFont(name: "Helvetica neue", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "female"
        label.textColor = .black
        label.font = UIFont(name: "Helvetica neue", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var maleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("No", for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "unselected_state")!, for: .normal)
        
       
        button.setImage(UIImage(named: "selected_state")!, for: .selected)
        button.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var femaleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("No", for: .normal)
        button.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "unselected_state")!, for: .normal)
        
       
        button.setImage(UIImage(named: "selected_state")!, for: .selected)
        button.addTarget(self, action: #selector(genderButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var submitProfileButton:UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func loadPickerViewData(){
        hobbies = ["Select hobby","coding","video games", "reading", "sports", "outdoor activities", "rock climbing", "travelling"]
        sortOptions = ["All profiles","female only", "male only", "age - 1...10", "age - 10...1","name - a-z", "name - z-a"]
    }
    
    func loadProfiles(withOptionChosen:String){
        aprofile = []
        dbRef = Database.database().reference()

        dbRef.child("profile").queryOrderedByKey().observe(DataEventType.childAdded) { (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }

            let name = dict["name"] as! String
            let age = dict["age"] as! String
            let gender = dict["gender"] as! String
            let firstHobby = dict["firstHobby"] as! String
            let secondHobby = dict["secondHobby"] as! String
            let imageURL = dict["imageUrl"] as! String
            let key = dict["key"] as! String
            self.id = dict["id"] as! Int

            self.downLoadUserProfile(name: name, age: age, gender: gender, firstHobby: firstHobby, secondHobby: secondHobby,url: imageURL,key:key)
            
        }
    }

    func downLoadUserProfile(name:String,age:String,gender:String,firstHobby:String,secondHobby:String,url:String,key:String){

        let pro = Profile(name: name, gender: gender, age: age, id: id, firstHobby: firstHobby, secondHobby: secondHobby, key:key, imageUrl: url)
        self.sortByOptions(gender: gender, profile: pro,age:age, name: name)
    }
    

    func sortByOptions(gender:String, profile:Profile, age:String, name:String){
        if pickerViewOptionChose == "age - 1...10"{
            
            sortListByAge(age: age, profile: profile, name: name)
            return
        }
        
        if pickerViewOptionChose == "age - 10...1"{
            sortListByDescendingAge(age: age, profile: profile, name: name)
            return
        }
        
        if pickerViewOptionChose == "name - a-z"{
            sortListByAscendingName(age: age, profile: profile, name: name)
            return
        }
        if pickerViewOptionChose == "name - z-a"{
            sortListByDescendingName(age: age, profile: profile, name: name)
            return
        }
        if pickerViewOptionChose == "female only"{
            if gender == "female"{
                self.aprofile.append(profile)
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
                return
            }
        } else if pickerViewOptionChose == "male only" {
            if gender == "male" {
                self.aprofile.append(profile)
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
                return
            }
        } else {
            sortDefaultListByAscendingingID(age: age, profile: profile, name: name)

        }
     
        
    }

    func sortListByAge(age:String, profile:Profile, name:String){
        aprofile.append(profile)
      let ageSorted = aprofile.sorted(by: { $0.age < $1.age})
         aprofile = []
        for uuser in ageSorted{
           
            if uuser.age == profile.age || uuser.id == profile.id{
  
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            } else {
                
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
            
        }
    
    }
    
    func sortListByDescendingAge(age:String, profile:Profile, name:String){
        //aprofile = []
       
        aprofile.append(profile)
        let ageSorted = aprofile.sorted(by: { $0.age > $1.age})
        aprofile = []
        for uuser in ageSorted{
            
            if uuser.age == profile.age || uuser.id == profile.id{
                print(uuser.age)
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            } else {
                
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
            
        }
        
    }
    func sortListByAscendingName(age:String, profile:Profile, name:String){
 
        aprofile.append(profile)
        let ageSorted = aprofile.sorted(by: { $0.name < $1.name})
        aprofile = []
        for uuser in ageSorted{
           
            if uuser.name == profile.name || uuser.id == profile.id{
               
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            } else {
                
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
            
        }
    }
    
    func sortListByDescendingName(age:String, profile:Profile, name:String){
 
        aprofile.append(profile)
        let ageSorted = aprofile.sorted(by: { $0.name > $1.name})
        aprofile = []
        for uuser in ageSorted{
            
            if uuser.name == profile.name{
    
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            } else {
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
            
        }
        
    }
    
    func sortDefaultListByAscendingingID(age:String, profile:Profile, name:String){
 
        aprofile.append(profile)
        let ageSorted = aprofile.sorted(by: { $0.id < $1.id})
        aprofile = []
        for uuser in ageSorted{
            
            if uuser.age == profile.age || uuser.id == profile.id{

                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            } else {
                let pro = Profile(name: uuser.name, gender: uuser.gender, age: uuser.age, id: uuser.id, firstHobby: uuser.firstHobby, secondHobby: uuser.secondHobby, key:uuser.key, imageUrl: uuser.imageUrl)
                aprofile.append(pro)
                
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            }
            
        }
        
    }
    //Counter for unique ID
    func incrementID()->Int{
        if id != nil{
            return id + 1
        }
        return 1
    }
    
    //navigation action buttons
    @objc func userImgButtonTapped(){
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
           
            self.userImg = image
            self.userImgButton.setImage(self.userImg, for: .normal)
            
            
            DB.shared.uploadImg(img: self.userImg)
            
        }
    }
    //Add new profile user
    @objc func submitButtonTapped(){
    
       // profileTableView.isHidden = false
        
        if self.userImg == nil{
            //alert no image added
            AlertHandler.shared.userDataMissingAlert(vc: self)
            clearNameAndAgeTextfield()
            return
        }
        if let name = nameTF.text, let age = ageTF.text, let gender = genderChosen, let firstHobby = firstHobbyChosen, let secondHobby = secondHobbyChosen {
            let counter = incrementID()
            DB.shared.addNewUserProfile(name: name, age: age, gender: gender, firstHobby: firstHobby, secondHobby: secondHobby, id:counter)
            
            let pc = ProfileController()
            let controllerNav = UINavigationController(rootViewController: pc)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = controllerNav
        } else {
            //alert user to add data
            //clear fields
            AlertHandler.shared.userDataMissingAlert(vc:self)
            
            return
        }
    }
    func clearNameAndAgeTextfield(){
        self.nameTF.text = ""
        self.ageTF.text = ""
    }
//Show new profile overlay
    @objc func addButtonTapped(){
        overlayView.isHidden = false
        profileTableView.isHidden = true
        hideKeyboardWhenTappedAround()

        
    }
    //reset all profiles to default
    @objc func refreshButtonTapped(){
        let pc = ProfileController()
        let controllerNav = UINavigationController(rootViewController: pc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = controllerNav
    }
    //Cancel new profile overlay
    @objc func cancelButtonTapped(){
  
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
        }
        overlayView.isHidden = true
        profileTableView.isHidden = false
    }
    //gender selection made
    @objc func genderButtonTapped(sender:UIButton){
        for button in buttons {
            button.isSelected = false
            let buttonIndex = buttons.index(of: sender)
            
            if buttonIndex == 0{
                //male button tapped
                genderChosen = "male"
            } else if buttonIndex == 1{
                //female button tapped
                genderChosen = "female"
   
            }
        }
        sender.isSelected = true
    }
    //Navigation Button Items
    func navigationBarItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
    }

    func controllerNav(profileX:Profile){
        let dvc = DetailViewController()
        
        dvc.profile = profileX
        
        let controllerNav = UINavigationController(rootViewController: dvc)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = controllerNav
    }
    func addSubViews(){
        view.addSubview(profileTableView)
        view.addSubview(filterPickerView)
        view.addSubview(overlayView)
        overlayView.addSubview(userImgButton)
        overlayView.addSubview(nameTF)
        overlayView.addSubview(ageTF)
        overlayView.addSubview(submitProfileButton)
        overlayView.addSubview(maleButton)
        overlayView.addSubview(femaleButton)
        overlayView.addSubview(genderSelectLabel)
        overlayView.addSubview(maleLabel)
        overlayView.addSubview(femaleLabel)
        overlayView.addSubview(firstHobbyPickerView)
        overlayView.addSubview(secondHobbyPickerView)
        overlayView.addSubview(cancelButton)
        buttons.append(maleButton)
        buttons.append(femaleButton)
    }
    func setupLayout() {

        overlayView.isHidden = true
        
        NSLayoutConstraint.activate([

            overlayView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            overlayView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            overlayView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            overlayView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            overlayView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            overlayView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        
            
            userImgButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.topAnchor, constant: 10),
            userImgButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.centerXAnchor),
            userImgButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 90),
            userImgButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 90),
            
            nameTF.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImgButton.safeAreaLayoutGuide.bottomAnchor, constant:15),
            nameTF.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTF.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            nameTF.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),

            ageTF.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameTF.safeAreaLayoutGuide.bottomAnchor, constant:10),
            ageTF.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ageTF.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            ageTF.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 80),
            
            genderSelectLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameTF.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            genderSelectLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: ageTF.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            genderSelectLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            
            maleButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderSelectLabel.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            maleButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: ageTF.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            maleButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            maleButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30),
            
            
            maleLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderSelectLabel.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            maleLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: maleButton.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            maleLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),

            femaleButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderSelectLabel.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            femaleButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: maleLabel.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            femaleButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            femaleButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30),
            
            femaleLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: genderSelectLabel.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            femaleLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: femaleButton.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            femaleLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            
            firstHobbyPickerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: ageTF.safeAreaLayoutGuide.bottomAnchor, constant: 50),
            firstHobbyPickerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.centerXAnchor),
            firstHobbyPickerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50),
            
            secondHobbyPickerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: firstHobbyPickerView.safeAreaLayoutGuide.bottomAnchor, constant: 40),
            secondHobbyPickerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.centerXAnchor),
            secondHobbyPickerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50),

            submitProfileButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            submitProfileButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            submitProfileButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 40),
            submitProfileButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            cancelButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: submitProfileButton.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.centerXAnchor),
            cancelButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30),
            
            filterPickerView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            filterPickerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterPickerView.heightAnchor.constraint(equalToConstant: 50),
            
            profileTableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: filterPickerView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            profileTableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileTableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            profileTableView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
