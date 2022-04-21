//
//  LoginViewController.swift
//  courseProjectFlats
//
//  Created by Serhii Kopytchuk on 18.02.2022.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rigthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rigthSwipe.direction = .right
        self.view.addGestureRecognizer(rigthSwipe)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if nickNameTextField.text == "" || passwordTextField.text == ""{
                return
        }else{
            let realm = try! Realm()
            var isFindUser = false
            let users = realm.objects(User.self)
            let admins = realm.objects(Admin.self)
            let name = nickNameTextField.text
            let password = passwordTextField.text
            for admin in admins{
                if admin.name == name{
                    if admin.password == password{
                        //go to vc
                        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AdminViewController") as? AdminViewController else { return }
                        navigationController?.pushViewController(controller, animated: true)
                        return
                    }
                }
            }
            //search users with this names
            for user in users{
                if user.name == name{
                    isFindUser = true
                    if user.password == password{
                        
                        //make all users inactive
                        realm.beginWrite()
                        for user in users{
                            user.current = false
                        }
                    
                        user.current = true
                        user.isAutorized = false
                        try! realm.commitWrite()
                        

                        self.navigationController?.popToRootViewController(animated: true)

                    }else{
                        presentAlertWithTitle(title: "Incorect Password", message: "Try another password", options: "try again") { (option) in
                            return
                        }
                    }
                }
            }
            if !isFindUser{
                presentAlertWithTitle(title: "We can't find user with this NickName", message: "Try another name ", options: "try again") { (option) in
                    return
                }
                return
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
