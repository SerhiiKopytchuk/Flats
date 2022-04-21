//
//  buyFlatViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 28.02.2022.
//

import UIKit
import RealmSwift

class buyFlatViewController: UIViewController {
    
    
    @IBOutlet weak var flatNameLabel: UILabel!
    
    @IBOutlet weak var aboutLabel: UITextView!
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var RoomsLabel: UILabel!
    @IBOutlet weak var sityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var flatLabel: UILabel!
    @IBOutlet weak var florLabel: UILabel!
    @IBOutlet weak var ownerNumberLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var flatImageView: UIImageView!
    
    
    var fromUser = false
    let realm = try! Realm()
    var id:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addRecognizers()
        strartSetup()
        checkForZeros()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        strartSetup()
    }
    
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        
        
        presentAlertWithTitle(title: "Buy", message: "Do you realy want to buy this flat?", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                let user = User.getCurrentUser()
                let flat = self.realm.objects(Flat.self).filter("id == \(self.id)").first
                self.realm.beginWrite()
                
                
                var index = 0
                guard let FormerOwner:User = flat?.owner else {return}
                
                for i in FormerOwner.flats.indices{
                    if FormerOwner.flats[i].id == flat?.id{
                        index = i
                    }
                }
                
                FormerOwner.flats.remove(at: index)
                
                flat?.ownerId = user.id
                flat!.owner = user
                user.flats.append(flat ?? Flat())
                try! self.realm.commitWrite()
                self.navigationController?.popToRootViewController(animated: true)
            default:
                return
            }
        }
        
        //some alert and go back
    }
    
    @IBAction func ownerButtonPressed(_ sender: UIButton) {
        if fromUser {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let flat = realm.objects(Flat.self).filter("id == \(id)").first
        let owner = realm.objects(User.self).filter("id == \(flat?.ownerId ?? 0)").first
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "userViewController") as! userViewController
        controller.userId = owner?.id ?? 0
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addRecognizers(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func strartSetup(){
        let flat = realm.objects(Flat.self).filter("id == \(id)").first
        let owner = realm.objects(User.self).filter("id == \(flat?.ownerId ?? 0)").first
        
        flatNameLabel.text = flat?.name
        aboutLabel.text = flat?.about
        squareLabel.text = String(flat?.square ?? 0)
        RoomsLabel.text = String(flat?.rooms ?? 0)
        sityLabel.text = flat?.sity
        streetLabel.text = flat?.street
        buildingLabel.text = String(flat?.BuildingNum ?? 0)
        flatLabel.text = String(flat?.FlatNum ?? 0)
        florLabel.text = String(flat?.floorNum ?? 0)
        ownerNumberLabel.text = String(owner?.phoneNumber ?? 0)
        
        
        flatImageView.image = Manager.shared.retrieveImage(forKey: "\(flat?.id ?? 0)FlatImage", inStorageType: .fileSystem)
        
        var number:String = String(ownerNumberLabel.text ?? "")
        number.removeLast(2)
        if number == "0"{
            ownerNumberLabel.text = "Uesr haven't number"
        }else{
            ownerNumberLabel.text = number
        }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        
        createdDateLabel.text = formatter.string(from: flat?.createdDate ?? Date())
        priceLabel.text = String(flat?.price ?? 0)
        priceLabel.text! += " $"
        
//        ownerButton.titleLabel?.text = owner?.name
        ownerButton.setTitle(owner?.name, for: .normal)
    }
    
    func checkForZeros(){
        if squareLabel.text == "0"{
            squareLabel.text = ""
        }
        if RoomsLabel.text == "0"{
            RoomsLabel.text = ""
        }
        if buildingLabel.text == "0"{
            buildingLabel.text = ""
        }
        if flatLabel.text == "0"{
            flatLabel.text = ""
        }
        if florLabel.text == "0"{
            florLabel.text = ""
        }
        if ownerNumberLabel.text == "0.0"{
            ownerNumberLabel.text = "NoNumber"
        }
        if priceLabel.text == "0 $"{
            priceLabel.text = "NoData"
        }
    }
    
    
}
