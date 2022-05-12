//
//  EditOrDelStudioViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import UIKit
import RealmSwift

class EditOrDelStudioViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var peopleCapacityTextField: UITextField!
    @IBOutlet weak var haveShowerSwitch: UISwitch!
    @IBOutlet weak var haveRelaxRoomSwitch: UISwitch!
    @IBOutlet weak var squareTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var flatNumberTextField: UITextField!
    @IBOutlet weak var florTextField: UITextField!
    @IBOutlet weak var studioImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!

    
    let realm = try! Realm()
    
    var city:String?
    var id:Int = 0
    let cities = [
        "Київ",
        "Харків",
        "Одеса",
        "Дніпро",
        "Донецьк",
        "Запоріжжя",
        "Львів",
        "Кривий Ріг",
        "Миколаїв",
        "Севасто́поль",
        "Маріуполь",
        "Луганськ",
        "Вінниця"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let studio = realm.objects(Studio.self).filter("id == \(id)").first
        
        nameTextField.text = studio?.name
        aboutTextView.text = studio?.about
        squareTextField.text = String(studio?.square ?? 0)
        roomsTextField.text = String(studio?.rooms ?? 0)
        
        let studioImage = Manager.shared.retrieveImage(forKey: "\(studio?.id ?? 0)StudioImage", inStorageType: .fileSystem)
        studioImageView.image = studioImage
        
        var cityNum = 0
        for i in cities.indices {
            if studio?.sity == cities[i]{
                cityNum = i
            }
        }
        
        cityPickerView.selectRow(cityNum, inComponent: 0, animated: true)
        
        streetTextField.text = studio?.street
        buildingNumberTextField.text = String(studio?.BuildingNum ?? 0)
        flatNumberTextField.text = String(studio?.FlatNum ?? 0)
        florTextField.text = String(studio?.floorNum ?? 0)
        priceTextField.text = String(studio?.price ?? 0)
        
        peopleCapacityTextField.text = String(studio?.peopleCapacity ?? 0)
        haveShowerSwitch.isOn = studio?.haveShower ?? false
        haveRelaxRoomSwitch.isOn = studio?.haveRelaxRoom ?? false
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        showPicker()
    }
    
    override func handlePickedImage(_ image: UIImage) {
        studioImageView.image = image
    }
    
    @IBAction func deletePhotoButtonPressed(_ sender: UIButton) {
        studioImageView.image = UIImage()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        realm.beginWrite()
        guard let studio = realm.objects(Studio.self).filter("id == \(id)").first else { return }
        let user = realm.objects(User.self).filter("current == true").first
        let userStudios = realm.objects(UserStudio.self)
        var timeObj = 0
        for userStudio in userStudios{
            if userStudio.studio?.id == studio.id{
                if userStudio.user?.id == user?.id{
                    if timeObj == 0{
                        realm.delete(userStudio)
                        timeObj += 1
                    }
                }
            }
        }
        var timeDel = 0
        let userStudios1 = realm.objects(UserStudio.self)
        for userStudio1 in userStudios1{
            if userStudio1.studio?.id == studio.id{
                timeDel += 1
            }
        }
        
        if timeDel == 0{
            realm.delete(studio)
        }
        try! realm.commitWrite()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyChangesButtonPressed(_ sender: UIButton) {
        if !checkEmptyTextFields(){
            return
        }
    
        let studio = realm.objects(Studio.self).filter("id == \(id)").first
        
        
        guard let studioImage = studioImageView.image else {return}
        Manager.shared.store(image: studioImage, forKey: "\(studio?.id ?? 0)StudioImage", withStorageType: .fileSystem)
        
        realm.beginWrite()
        studio?.name = nameTextField.text
        studio?.about = aboutTextView.text
        studio?.square = Int(squareTextField.text ?? "") ?? 0
        studio?.rooms = Int(roomsTextField.text ?? "") ?? 0
        
        studio?.sity = city
        
        studio?.street = streetTextField.text
        studio?.BuildingNum = Int(buildingNumberTextField.text ?? "") ?? 0
        studio?.FlatNum = Int(flatNumberTextField.text ?? "") ?? 0
        studio?.floorNum = Int(florTextField.text ?? "") ?? 0
        studio?.price = Int(priceTextField.text ?? "") ?? 0
        
        studio?.peopleCapacity = Int(peopleCapacityTextField.text ?? "") ?? 0
        studio?.haveShower = haveShowerSwitch.isOn
        studio?.haveRelaxRoom = haveRelaxRoomSwitch.isOn
        
        try! realm.commitWrite()
        
        presentAlertWithTitle(title: "Success", message: "Changes was applied", options: "Nice") { (option) in
            return
        }
    }
    
    func checkEmptyTextFields() -> Bool{
        if nameTextField.text == ""{
            presentAlertWithTitle(title: "No name", message: "Name field is empty", options: "close") { (option) in
                return
            }
            return false
        }
        if aboutTextView.text == ""{
            presentAlertWithTitle(title: "About field is empty", message: "Give some details about your flat", options: "close") { (option) in
                return
            }
            return false
        }
        if squareTextField.text == ""{
            presentAlertWithTitle(title: "We need to know square of your flat", message: "Write square of your flat", options: "close") { (option) in
                return
            }
            return false
        }
        if roomsTextField.text == ""{
            presentAlertWithTitle(title: "How much rooms in your flat?", message: "write amount of rooms", options: "close") { (option) in
                return
            }
            return false
        }
        if streetTextField.text == ""{
            presentAlertWithTitle(title: "Street field is empty", message: "write street of your flat", options: "close") { (option) in
                return
            }
            return false
        }
        if buildingNumberTextField.text == ""{
            presentAlertWithTitle(title: "Building field is empty", message: "write number of your building", options: "close") { (option) in
                return
            }
            return false
        }
        if flatNumberTextField.text == ""{
            presentAlertWithTitle(title: "Flat field is empty", message: "write number of your flat", options: "close") { (option) in
                return
            }
            return false
        }
        if florTextField.text == ""{
            presentAlertWithTitle(title: "Flor field is empty", message: "write number of your flor", options: "close") { (option) in
                return
            }
            return false
        }
        if priceTextField.text == ""{
            presentAlertWithTitle(title: "Price field is empty", message: "how much cost your flat", options: "close") { (option) in
                return
            }
            return false
        }
        return true
    }



}

extension EditOrDelStudioViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        city = cities[row]
    }
    
}

