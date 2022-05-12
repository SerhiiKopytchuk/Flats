//
//  AccountViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 20.02.2022.
//

import UIKit
import RealmSwift
class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    var user:User?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        registerForKeyboardNotifications()
        
        let realm = try! Realm()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        user = realm.objects(User.self).filter("current == true").first
        
        nameTextField.text = user?.name
        

        
        if user?.phoneNumber != 0.0{
            var number:String = String(user!.phoneNumber)
            number.removeLast(2)
            phoneNumberTextField.text = number
        }
        
        
        guard let profileImage = Manager.shared.retrieveImage(forKey: "\(user?.name ?? "")ProfileImage", inStorageType: .fileSystem) else {return}
        profileImageView.image = profileImage
    }
    
    
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        showPicker()
    }
    

    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        presentAlertWithTitle(title: "Delete account", message: "Do you realy want to delete account?", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                
                
                self.presentAlertWithTitle(title: "Delete flats and studios?", message: "Do you realy want to delete all your studios and flats?", options: "no", "yes") { (option) in
                    switch (option){
                    case 0:
                        let realm = try! Realm()
                        let users = realm.objects(User.self)
                        realm.beginWrite()
                        self.user = realm.objects(User.self).filter("current == true").first
                        users.realm?.delete(self.user ?? User())
                        try! realm.commitWrite()
                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    case 1:
                        let realm = try! Realm()
                        let user = realm.objects(User.self).filter("current == true").first
        
                        let flats = realm.objects(Flat.self).filter("owner.id == \(user?.id ?? 0)")
                        for flat in flats{
                            realm.beginWrite()
                            realm.delete(flat)
                            try! realm.commitWrite()
                        }
                        let userStudios = realm.objects(UserStudio.self).filter("user.id == \(user?.id ?? 0)")
                        for userStudio in userStudios{
                            var count = 0
                            let userStudios1 = realm.objects(UserStudio.self).filter("user.id == \(user?.id ?? 0)")
                            for userStudio1 in userStudios1{
                                if userStudio.studio?.id == userStudio1.studio?.id{
                                    count += 1
                                }
                            }
                            realm.beginWrite()
                            if count == 1{
                                let studio = realm.objects(Studio.self).filter("id == \(userStudio.studio?.id ?? 0)")
                                realm.delete(studio)
                                realm.delete(userStudio)
                            }else{
                                realm.delete(userStudio)
                            }
                            try! realm.commitWrite()
                            
                        }
                        
                        

                        let users = realm.objects(User.self)
                        realm.beginWrite()
                        self.user = realm.objects(User.self).filter("current == true").first
                        users.realm?.delete(self.user ?? User())
                        try! realm.commitWrite()
                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(controller, animated: true)
//                        var timeObj = 0
//                        for userStudio in userStudios{
//
//                                if userStudio.user?.id == user?.id{
//                                    if timeObj == 0{
//                                        realm.delete(userStudio)
//                                        timeObj += 1
//                                    }
//                                }
//
//                        }
//                        var timeDel = 0
//                        let userStudios1 = realm.objects(UserStudio.self)
//                        for userStudio1 in userStudios1{
//                            if userStudio1.studio?.id == studio.id{
//                                timeDel += 1
//                            }
//                        }
//
//                        if timeDel == 0{
//                            realm.delete(studio)
//                        }
//                        try!
                    default:
                        return
                    }
                    
                }
                
                
            default:
                return
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeNameButton(_ sender: UIButton) {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        for user in users{
            if user.name == nameTextField.text{
                presentAlertWithTitle(title: "Incorrect nickname", message: "This nickname is used by other person", options: "Ok") { (option) in
                    return
                }
                return
            }
        }
        realm.beginWrite()
        user?.name = nameTextField.text
        try! realm.commitWrite()
        presentAlertWithTitle(title: "Success", message: "Your nickname is changed", options: "Nice") { (option) in
            return
        }
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        let realm = try! Realm()
        let password = NewPasswordTextField.text
        
        if password?.count ?? 0 <= 4{
            presentAlertWithTitle(title: "Incorrect password", message: "Password lenght must be longer than 4", options: "try again") { (option) in
                return
            }
            NewPasswordTextField.text = ""
            oldPasswordTextField.text = ""
            confirmPasswordTextField.text = ""
            return
        }
        if NewPasswordTextField.text != confirmPasswordTextField.text{
            NewPasswordTextField.text = ""
            confirmPasswordTextField.text = ""
            presentAlertWithTitle(title: "Incorect Passwords", message: "Password and confirmation password not the same", options: "try again") { (option) in
                return
            }
            return
        }
        realm.beginWrite()
        user?.password = NewPasswordTextField.text
        try! realm.commitWrite()
        presentAlertWithTitle(title: "Success", message: "Passsword has been changed", options: "Nice") { (option) in
            return
        }
        NewPasswordTextField.text = ""
        oldPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    @IBAction func changeNumberButtonPressed(_ sender: UIButton) {
        let realm = try! Realm()
        guard let numberInDouble = Double(phoneNumberTextField.text!) else {
            phoneNumberTextField.text = ""
            presentAlertWithTitle(title: "Failure", message: "password must contains only numbers", options: "try again") { (option) in
                return
            }
            return
        }
        
        realm.beginWrite()
        user?.phoneNumber = numberInDouble
        try! realm.commitWrite()
        presentAlertWithTitle(title: "Success", message: "Phone number has been changed", options: "Nice") { (option) in
            return
        }
    }
    
    override func handlePickedImage(_ image: UIImage) {
        profileImageView.image = image
        let realm = try! Realm()
        user = realm.objects(User.self).filter("current == true").first
        
        Manager.shared.store(image: image, forKey: "\(user?.name ?? "")ProfileImage", withStorageType: .fileSystem)
    }
    
    

    
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = keyboardScreenEndFrame.height + 10
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

