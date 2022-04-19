//
//  FriendsViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 19.04.2022.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        
        let usersCount = realm.objects(User.self).filter("current == false").count
        
        return usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as? FriendsTableViewCell else {return UITableViewCell()}
        let realm = try! Realm()
        //        print(indexPath.row)
        let users = realm.objects(User.self).filter("current == false")
        cell.delegate = self
        cell.nameLabel.text = users[indexPath.row].name
        cell.userId = users[indexPath.row].id
        
        
        
        return cell
    }
    
    
}

extension FriendsViewController: FriendsTableViewCellDelegate{
    
    func addButtonPressed(userId: Int, name:String) {
        let realm = try! Realm()
        let currentUser = realm.objects(User.self).filter("current == true").first
        let friendsId = currentUser?.friendsId ?? List<Int>()
        
        
        for friendId in friendsId{
            if friendId == userId{
                
                presentAlertWithTitle(title: "Friends list", message: "this user is your frined already", options: "Nice") { _ in }
                return
            }
        }
        
        realm.beginWrite()
        currentUser?.friendsId.append(userId)
        
        presentAlertWithTitle(title: "Friends list", message: "user was added to your friends list", options: "Nice") { _ in }
        
        try! realm.commitWrite()
    }
}
