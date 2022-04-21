//
//  mainViewController.swift
//  courseProjectFlats
//
//  Created by Serhii Kopytchuk on 18.02.2022.
//

import UIKit
import RealmSwift

class mainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SearchFlatsButtonPressed(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rigthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(logoutButtonPressed(_:)))
        rigthSwipe.direction = .right
        self.view.addGestureRecognizer(rigthSwipe)
        
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("current == true").first
        realm.beginWrite()
        user?.isAutorized = false
        try! realm.commitWrite()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        
        guard let user = realm.objects(User.self).filter("current == true").first else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController" ) as! ViewController
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        
        if user.isAutorized == false{
            if user.appPassword == ""{
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "passwordViewController") as! passwordViewController
                controller.text = "set password"
                self.navigationController?.pushViewController(controller, animated: false)
            }else{
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "passwordViewController") as! passwordViewController
                controller.text = "password"
                self.navigationController?.pushViewController(controller, animated: false)
            }
        }
    }
    
    @IBAction func UsersButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController else { return}
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func myFriendsButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "MyFriendsViewController") as? MyFriendsViewController else { return}
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "ChooseFlatOrStudioViewController") as! ChooseFlatOrStudioViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func AccountButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "AccountViewController") as! AccountViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        presentAlertWithTitle(title: "Logout", message: "Do you realy want to logout?", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                
                let realm = try! Realm()
                let users = realm.objects(User.self)
                realm.beginWrite()
                for user in users{
                    user.current = false
                }
                try! realm.commitWrite()
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                return
            }
        }
        
    }
    @IBAction func myFlatsButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "MyFlatsViewController") as! MyFlatsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func SearchFlatsButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "searchFlatsViewController") as! searchFlatsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
