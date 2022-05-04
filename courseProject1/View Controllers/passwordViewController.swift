//
//  passwordViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 07.03.2022.
//

import UIKit
import RealmSwift
class passwordViewController: UIViewController {
    
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var forthView: UIView!
    
    
    
    var text = ""
    var timePassword:String?
    let realm = try! Realm()
   
    var password = ""{
        didSet{
            switch password.count{
            case 0:
                firstView.isHidden =  true
                secondView.isHidden =  true
                thirdView.isHidden =  true
                forthView.isHidden =  true
            case 1:
                firstView.isHidden =  false
                secondView.isHidden =  true
                thirdView.isHidden =  true
                forthView.isHidden =  true
            case 2:
                firstView.isHidden =  false
                secondView.isHidden =  false
                thirdView.isHidden =  true
                forthView.isHidden =  true
            case 3:
                firstView.isHidden =  false
                secondView.isHidden =  false
                thirdView.isHidden = false
                forthView.isHidden =  true
            case 4:
                firstView.isHidden =  false
                secondView.isHidden =  false
                thirdView.isHidden = false
                forthView.isHidden =  false
                let user = realm.objects(User.self).filter("current == true").first
                if mainLabel.text == "retry password"{
                    if password == timePassword{
                        realm.beginWrite()
                        user?.appPassword = password
                        try! realm.commitWrite()
                        mainLabel.text = "password"
                        password = ""
                        firstView.isHidden =  true
                        secondView.isHidden =  true
                        thirdView.isHidden =  true
                        forthView.isHidden =  true
                    }else{
                        
                        //alert that password is not the same
                        presentAlertWithTitle(title: "Incorrect password", message: "Two passwords must be the same", options: "retry") { (option) in
                            return
                        }
                        password = ""
                        timePassword = ""
                        mainLabel.text = "set password"
                        firstView.isHidden =  true
                        secondView.isHidden =  true
                        thirdView.isHidden =  true
                        forthView.isHidden =  true
                    }
                } else if mainLabel.text == "set password"{
                    timePassword = password
                    password = ""
                    mainLabel.text = "retry password"
                    firstView.isHidden =  true
                    secondView.isHidden =  true
                    thirdView.isHidden =  true
                    forthView.isHidden =  true
                } else if mainLabel.text == "password"{
                    if user?.appPassword == password{
                        self.navigationController?.popToRootViewController(animated: false)
                    }else{
                        presentAlertWithTitle(title: "Incorrect password", message: "try another password", options: "retry") { (option) in
                            return
                        }
                        firstView.isHidden =  true
                        secondView.isHidden =  true
                        thirdView.isHidden =  true
                        forthView.isHidden =  true
                        password = ""
                    }
                    realm.beginWrite()
                    user?.isAutorized = true
                    try! realm.commitWrite()
                }else if mainLabel.text == "old password"{
                    if password == user?.appPassword{
                        mainLabel.text = "set password"
                        password = ""
                        timePassword = ""
                        firstView.isHidden =  true
                        secondView.isHidden =  true
                        thirdView.isHidden =  true
                        forthView.isHidden =  true
                    }else{
                        presentAlertWithTitle(title: "Incorrect password", message: "try another password", options: "retry") { (option) in
                            return
                        }
                        firstView.isHidden =  true
                        secondView.isHidden =  true
                        thirdView.isHidden =  true
                        forthView.isHidden =  true
                        password = ""
                    }
                }
            default:
                firstView.isHidden =  false
                secondView.isHidden =  false
                thirdView.isHidden = false
                forthView.isHidden =  false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.layer.cornerRadius = firstView.frame.width/2
        secondView.layer.cornerRadius = secondView.frame.width/2
        thirdView.layer.cornerRadius = thirdView.frame.width/2
        forthView.layer.cornerRadius = forthView.frame.width/2
        
        mainLabel.text = text
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(logoutButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        
        firstView.isHidden =  true
        secondView.isHidden =  true
        thirdView.isHidden =  true
        forthView.isHidden =  true
    }
    
    
    @IBAction func buttonOnePressed(_ sender: UIButton) {
        password += "1"
    }
    @IBAction func buttonTwoPressed(_ sender: UIButton) {
        password += "2"
    }
    @IBAction func buttonThreePressed(_ sender: UIButton) {
        password += "3"
    }
    @IBAction func buttonFourPressed(_ sender: UIButton) {
        password += "4"
    }
    @IBAction func ButtonFivePressed(_ sender: UIButton) {
        password += "5"
    }
    @IBAction func buttonSixPressed(_ sender: UIButton) {
        password += "6"
    }
    @IBAction func buttonSevenPressed(_ sender: UIButton) {
        password += "7"
    }
    @IBAction func buttonEightPressed(_ sender: UIButton) {
        password += "8"
    }
    @IBAction func buttonNinePressed(_ sender: UIButton) {
        password += "9"
    }
    @IBAction func buttonZeroPressed(_ sender: UIButton) {
        password += "0"
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        password = ""
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if password.count > 0{
            password.removeLast()
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        
        presentAlertWithTitle(title: "Logout", message: "Do you realy want to logout?", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                let users = self.realm.objects(User.self)
                self.realm.beginWrite()
                for user in users{
                    user.current = false
                }
                try! self.realm.commitWrite()
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(controller, animated: true)
            default:
                return
            }
        }
    }
    
    
}
