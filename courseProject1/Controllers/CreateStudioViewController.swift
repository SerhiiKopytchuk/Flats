//
//  CreateStudioViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import UIKit
import RealmSwift

class CreateStudioViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var peopleCapacityTextField: UITextField!
    @IBOutlet weak var haveShowerSwitch: UISwitch!
    @IBOutlet weak var haveRelaxRoomSwitch: UISwitch!
    @IBOutlet weak var squareTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var sityPickerView: UIPickerView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var flatNumberTextField: UITextField!
    @IBOutlet weak var florTextField: UITextField!
    @IBOutlet weak var studioImageView: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var city:String?
    var standartImage:UIImage?
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

        
        city = cities.first
        
        
        standartImage = studioImageView.image
        
        
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        showPicker()
    }
    
    @IBAction func DeleteButtonPressed(_ sender: UIButton) {
       studioImageView.image = standartImage
    }
    
    override func handlePickedImage(_ image: UIImage) {
        studioImageView.image = image
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        
        if !checkEmptyTextFields(){
            return
        }
        
//        check can we make convert to int
        if !canConvertToInt(){
            return
        }
        
        let realm = try! Realm()
        
        let user = realm.objects(User.self).filter("current == true").first
        
        let price = Int(priceTextField.text ?? "") ?? 0
        let square = Int(squareTextField.text ?? "") ?? 0
        let rooms = Int(roomsTextField.text ?? "") ?? 0
        let buildingNumber = Int(buildingNumberTextField.text ?? "") ?? 0
        let flatNumber = Int(flatNumberTextField.text ?? "") ?? 0
        let florNumber = Int(florTextField.text ?? "") ?? 0
        let peopleCapacity = Int(peopleCapacityTextField.text ?? "") ?? 0
        
        let id = realm.objects(Studio.self).count + 1
        
        let studio = Studio()
        
        studio.name = nameTextField.text
        studio.about = aboutTextView.text
        studio.sity = city
        studio.street = streetTextField.text
        studio.createdDate = Date.now
        studio.price = price
        studio.square = square
        studio.rooms = rooms
        studio.BuildingNum = buildingNumber
        studio.FlatNum = flatNumber
        studio.floorNum = florNumber
        studio.id = id
        studio.peopleCapacity = peopleCapacity
        studio.haveShower = haveShowerSwitch.isOn
        studio.haveRelaxRoom = haveRelaxRoomSwitch.isOn
        
        
        guard let studioImage = studioImageView.image else {return}
        Manager.shared.store(image: studioImage, forKey: "\(id)StudioImage", withStorageType: .fileSystem)
        
        let ownerId:Int = user?.id ?? 0

        studio.ownerId = ownerId
        studio.owner = user
        
        let UserStudioCount = realm.objects(UserStudio.self).count
        
        let userStudio = UserStudio()
        userStudio.user = user ?? User()
        userStudio.studio = studio
        userStudio.UserStudioId = UserStudioCount

    
        
        realm.beginWrite()
        user?.studios.append(studio)
        realm.add(studio)
        realm.add(userStudio)
        try! realm.commitWrite()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func canConvertToInt()->Bool{
        guard let peopleCapacity = peopleCapacityTextField.text else{
            return false
        }
        guard let price = priceTextField.text else{
            return false
        }
        guard let square = squareTextField.text else{
            return false
        }
        guard let rooms = roomsTextField.text else{
            return false
        }
        guard let buildingNumber = buildingNumberTextField.text else{
            return false
        }
        guard let flatNumber = flatNumberTextField.text else{
            return false
        }
        guard let flor = florTextField.text else{
            return false
        }
        guard let _ = Int(peopleCapacity)  else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(price)  else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(square) else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(rooms) else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(buildingNumber) else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(flatNumber) else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        guard let _ = Int(flor) else{
            alertFieldsMustContainsOnlyNumbers()
            return false
        }
        
        return true
    }
    
    func alertFieldsMustContainsOnlyNumbers(){
        presentAlertWithTitle(title: "Error", message: "some fields must contains only numbers", options: "close") { (option) in
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

extension CreateStudioViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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
