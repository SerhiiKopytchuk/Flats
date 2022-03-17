//
//  userViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 09.03.2022.
//

import UIKit
import RealmSwift
class userViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var userId = 0
    let realm = try! Realm()
    let cellID = "MyFlatsTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = realm.objects(User.self).filter("id == \(userId)").first
        
        nameLabel.text = user?.name
        phoneNumberLabel.text = String(user?.phoneNumber ?? 0)
        
        startSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 60;
        
        guard let profileImage = Manager.shared.retrieveImage(forKey: "\(user?.name ?? "")ProfileImage", inStorageType: .fileSystem) else {return}
        profileImageView.image = profileImage
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func startSetup(){
        var number:String = String(phoneNumberLabel.text ?? "")
        number.removeLast(2)
        if number == "0"{
            phoneNumberLabel.text = "Uesr haven't number"
        }else{
            phoneNumberLabel.text = number
        }
    }
    
}

extension userViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let user = realm.objects(User.self).filter("id == \(userId)").first

        return user?.flats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyFlatsTableViewCell
        let user = realm.objects(User.self).filter("id == \(userId)").first

        
        
        let flat = user?.flats[indexPath.row]
        
        cell.mainLabel.text = flat?.name
        cell.priceLabel.text = String(flat?.price ?? 0) + "$"
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "buyFlatViewController") as! buyFlatViewController
        controller.fromUser = true
        let user = realm.objects(User.self).filter("id == \(userId)").first
        let flat = user?.flats[indexPath.row]
        controller.id = flat?.id ?? 0

        self.navigationController?.pushViewController(controller, animated: true)
    }
}
