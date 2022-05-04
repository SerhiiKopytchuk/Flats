//
//  RegistraitionViewController.swift
//  courseProjectFlats
//
//  Created by Serhii Kopytchuk on 18.02.2022.
//

import UIKit
import RealmSwift

class RegistraitionViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rigthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rigthSwipe.direction = .right
        self.view.addGestureRecognizer(rigthSwipe)
        
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        if nickNameTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
                return
        }else{
            let realm = try! Realm()
            let name = nickNameTextField.text
            let password = passwordTextField.text
            let id:Int = realm.objects(User.self).count + 1
            let users = realm.objects(User.self)
            
            //is name is taken?
            for user in users{
                if name == user.name{
                    presentAlertWithTitle(title: "Name was taken", message: "Choose another nickname", options: "try again") { (option) in
                        return
                    }
                    return
                }
            }
            //check if password is longer than 4
            if password?.count ?? 0 <= 4{
                presentAlertWithTitle(title: "Incorrect password", message: "Password lenght must be longer than 4", options: "try again") { (option) in
                    return
                }
                passwordTextField.text = ""
                confirmPasswordTextField.text = ""
                return
            }
            // check if 2 passwords is the same
            if confirmPasswordTextField.text != passwordTextField.text{
                confirmPasswordTextField.text = ""
                presentAlertWithTitle(title: "Incorect Passwords", message: "Password and confirmation password not the same", options: "try again") { (option) in
                    return
                }
                passwordTextField.text = ""
                confirmPasswordTextField.text = ""
                return
            }
            
            //creating user
            let user = User()
            user.id = id
            user.name = name
            user.password = password
            
            realm.beginWrite()
            //make all users inactive

            for user in users{
                user.current = false
            }
            
            user.current = true
            realm.add(user)
            try! realm.commitWrite()
            
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
