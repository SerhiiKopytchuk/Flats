//
//  AdminViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import UIKit
import RealmSwift

class AdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                
                self.navigationController?.popViewController(animated: true)
            default:
                return
            }
        }
    }
    
    @IBAction func averagePriceOfFlatButtonPressed(_ sender: UIButton) {
        presentAlertWithTitle(title: "Statistic", message: "Average price of flat is: \(Admin.getAverageValueOfFlat())", options: "ok") { _ in }
    }
    @IBAction func sumPriceOfAllFlatsButtonPressed(_ sender: UIButton) {
        presentAlertWithTitle(title: "Statistic", message: "Sum price of flats is: \(Admin.getSumPriceOfAllFlats())", options: "ok") { _ in }
    }
    @IBAction func countOfAllFlatsButtonPressed(_ sender: UIButton) {
        presentAlertWithTitle(title: "Statistic", message: "Count of all flats is: \(Admin.getCountOfFlats())", options: "ok") { _ in }
    }
    @IBAction func countOfAllUsersButtonPressed(_ sender: UIButton) {
        presentAlertWithTitle(title: "Statistic", message: "Count of all users is: \(Admin.getCountOfUsers())", options: "ok") { _ in }
    }
    
    
}
