//
//  buyStudioViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import UIKit
import RealmSwift

class buyStudioViewController: UIViewController {
    
    @IBOutlet weak var studioNameLabel: UILabel!
    
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
    
    @IBOutlet weak var studioImageView: UIImageView!
    @IBOutlet weak var ownersLabel: UILabel!
    
    @IBOutlet weak var canContainPersonLabel: UILabel!
    @IBOutlet weak var haveShowerLabel: UILabel!
    @IBOutlet weak var haveRelaxRoomLabel: UILabel!
    
    var fromUser = false
    let realm = try! Realm()
    var id:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        strartSetup()
        checkForZeros()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        
        presentAlertWithTitle(title: "Buy", message: "Do you realy want to buy this studio?", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                let user = self.realm.objects(User.self).filter("current == true").first
                let studio = self.realm.objects(Studio.self).filter("id == \(self.id)").first
                self.realm.beginWrite()
                
                user?.studios.append(studio ?? Studio())
                
                try! self.realm.commitWrite()
                self.navigationController?.popToRootViewController(animated: true)
            default:
                return
            }
        }
        
    }
    
    func strartSetup(){
        let studio = realm.objects(Studio.self).filter("id == \(id)").first
        let owner = realm.objects(User.self).filter("id == \(studio?.ownerId ?? 0)").first
        
        studioNameLabel.text = studio?.name
        aboutLabel.text = studio?.about
        squareLabel.text = String(studio?.square ?? 0)
        RoomsLabel.text = String(studio?.rooms ?? 0)
        sityLabel.text = studio?.sity
        streetLabel.text = studio?.street
        buildingLabel.text = String(studio?.BuildingNum ?? 0)
        flatLabel.text = String(studio?.FlatNum ?? 0)
        florLabel.text = String(studio?.floorNum ?? 0)
        ownerNumberLabel.text = String(owner?.phoneNumber ?? 0)
        canContainPersonLabel.text = String(studio?.peopleCapacity ?? 0)
        
        switch studio?.haveRelaxRoom{
        case true:
            haveRelaxRoomLabel.text = "Yes"
        case false:
            haveRelaxRoomLabel.text = "No"
        default:
            break
        }
        
        switch studio?.haveShower{
        case true:
            haveShowerLabel.text = "Yes"
        case false:
            haveShowerLabel.text = "No"
        default:
            break
        }
        
        
        studioImageView.image = Manager.shared.retrieveImage(forKey: "\(studio?.id ?? 0)StudioImage", inStorageType: .fileSystem)
        
        var number:String = String(ownerNumberLabel.text ?? "")
        number.removeLast(2)
        if number == "0"{
            ownerNumberLabel.text = "Uesr haven't number"
        }else{
            ownerNumberLabel.text = number
        }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        
        createdDateLabel.text = formatter.string(from: studio?.createdDate ?? Date())
        priceLabel.text = String(studio?.price ?? 0)
        priceLabel.text! += " $"
        
        ownersLabel.text = getOwners()
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
    
    func getOwners()-> String{
        let studio = realm.objects(Studio.self).filter("id == \(id)").first
        guard let owners = studio?.owners else { return "" }
        var result = ""
        
        for owner in owners{
            result += owner.name ?? ""
            result += ", "
        }
        
        result.removeLast(2)
        
        return result
    }
    

}
