//
//  MyFriendsViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 19.04.2022.
//

import UIKit
import RealmSwift

class MyFriendsViewController: UIViewController {
    
    @IBOutlet weak var myFriendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
}

extension MyFriendsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("current == true").first
        let friendsCount = user?.friendsId.count
        return friendsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell") as? MyFriendsTableViewCell else {return UITableViewCell()}
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("current == true").first
        let friendsId = user?.friendsId
        let friend = realm.objects(User.self).filter("id == \(friendsId?[indexPath.row] ?? 0)").first
        
        cell.delegate = self
        
        cell.userId = friend?.id ?? 0
        cell.nameLabel.text = friend?.name
        
        return cell
    }
    
    
}

extension MyFriendsViewController:MyFriendsTableViewCellDelegate{
    func removeButtonPressed(userId: Int) {
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("current == true").first
        var friends = user?.friendsId
        if var friendsCount = friends?.count{
            friendsCount += -1
            let time = friendsCount
            for i in 0...friendsCount{
                if friendsCount == time{
                    if userId == friends![i]{
                        realm.beginWrite()
                        friendsCount += -1
                        friends?.remove(at: i)
                        try! realm.commitWrite()
                    }
                }
            }
            myFriendsTableView.reloadData()
        }
    }
}
