//
//  CreateFlatViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 23.02.2022.
//

import UIKit
import RealmSwift
import SwiftUI

class CreateFlatViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var squareTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var flatTextField: UITextField!
    @IBOutlet weak var florTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var flatImgaView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        registerForKeyboardNotifications()
        
        standartImage = flatImgaView.image
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
    }
    
    
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        showPicker()
    }
    
    
    override func handlePickedImage(_ image: UIImage) {
        flatImgaView.image = image
    }
    
    @IBAction func deletePhotoButtonPressed(_ sender: UIButton) {
        flatImgaView.image = standartImage
    }
    
    
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {

        if !checkEmptyTextFields(){
            return
        }
        
        //check can we make convert to int
        if !canConvertToInt(){
            return
        }
        
        let realm = try! Realm()
        
        var user = User()
        var isFindUser = false
        let users = realm.objects(User.self)
        for userInFor in users{
            if userInFor.current == true{
                user = userInFor
                isFindUser = true
                break
            }
        }
        
        if !isFindUser{
            return
        }
        
   
        let price = Int(priceTextField.text ?? "") ?? 0
        let square = Int(squareTextField.text ?? "") ?? 0
        let rooms = Int(roomsTextField.text ?? "") ?? 0
        let buildingNumber = Int(buildingNumberTextField.text ?? "") ?? 0
        let flatNumber = Int(flatTextField.text ?? "") ?? 0
        let florNumber = Int(florTextField.text ?? "") ?? 0
        
        let id = realm.objects(Flat.self).count + 1
       
        let flat = Flat()
        
        flat.name = nameTextField.text
        flat.about = aboutTextView.text
        flat.sity = city
        flat.street = streetTextField.text
        flat.createdDate = Date.now
        flat.price = price
        flat.square = square
        flat.rooms = rooms
        flat.BuildingNum = buildingNumber
        flat.FlatNum = flatNumber
        flat.floorNum = florNumber
        flat.id = id

        
        //save images
        guard let flatImage = flatImgaView.image else {return}
        Manager.shared.store(image: flatImage, forKey: "\(id)FlatImage", withStorageType: .fileSystem)
        

        let ownerId:Int = UserDefaults.standard.value(forKey: "userId") as! Int

        flat.ownerId = ownerId
        
    
        
        realm.beginWrite()
        user.flats.append(flat)
        realm.add(flat)
        try! realm.commitWrite()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func canConvertToInt()->Bool{
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
        guard let flatNumber = flatTextField.text else{
            return false
        }
        guard let flor = florTextField.text else{
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
//        if sityTextField.text == ""{
//            presentAlertWithTitle(title: "Sity field is empty", message: "write sity of your flat", options: "close") { (option) in
//                return
//            }
//            return false
//        }
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
        if flatTextField.text == ""{
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

    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = keyboardScreenEndFrame.height + 10
        }
        
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension CreateFlatViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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



