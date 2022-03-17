//
//  MyFlatsViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 26.02.2022.
//

import UIKit
import RealmSwift
class MyFlatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let realm = try! Realm()
    let cellID = "MyFlatsTableViewCell"



    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 100
    }
    
    override func viewDidLayoutSubviews() {
        tableView.reloadData()
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyFlatsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let user = realm.objects(User.self).filter("current == true").first

        return user?.flats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyFlatsTableViewCell
        let user = realm.objects(User.self).filter("current == true").first

        
        
        let flat = user?.flats[indexPath.row]
        
        let flatImage = Manager.shared.retrieveImage(forKey: "\(flat?.id ?? 0)FlatImage", inStorageType: .fileSystem)

    
        cell.configuration(name: flat?.name ?? "" , price: String(flat?.price ?? 0) + "$" ,image: flatImage ?? UIImage())

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "EditOrDeleteFlatViewController") as! EditOrDeleteFlatViewController
        let user = realm.objects(User.self).filter("current == true").first
        let flat = user?.flats[indexPath.row]
        controller.id = flat?.id ?? 0

        self.navigationController?.pushViewController(controller, animated: true)
    }
}
