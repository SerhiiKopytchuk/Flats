//
//  EditOrDeleteFlatViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 27.02.2022.
//

import UIKit
import RealmSwift

class EditOrDeleteFlatViewController: UIViewController {

    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var AboutTextView: UITextView!
    @IBOutlet weak var squareTextField: UITextField!
    @IBOutlet weak var RoomsTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var flatTextField: UITextField!
    @IBOutlet weak var florTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var flatImageView: UIImageView!
    
    
    let realm = try! Realm()
    var id:Int = 0
    
    var city:String?
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
        
        registerForKeyboardNotifications()
        
        

        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)

        let flat = realm.objects(Flat.self).filter("id == \(id)").first
        
        nameTextField.text = flat?.name
        AboutTextView.text = flat?.about
        squareTextField.text = String(flat?.square ?? 0)
        RoomsTextField.text = String(flat?.rooms ?? 0)
        
        
        let flatImage = Manager.shared.retrieveImage(forKey: "\(flat?.id ?? 0)FlatImage", inStorageType: .fileSystem)
        flatImageView.image = flatImage
        
        
        var cityNum = 0
        for i in cities.indices {
            if flat?.sity == cities[i]{
                cityNum = i
            }
        }
        
        cityPickerView.selectRow(cityNum, inComponent: 0, animated: true)
        
        
        streetTextField.text = flat?.street
        buildingNumberTextField.text = String(flat?.BuildingNum ?? 0)
        flatTextField.text = String(flat?.FlatNum ?? 0)
        florTextField.text = String(flat?.floorNum ?? 0)
        priceTextField.text = String(flat?.price ?? 0)
        
        
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        showPicker()
    }
    
    override func handlePickedImage(_ image: UIImage) {
        flatImageView.image = image
    }
    
    @IBAction func deletePhotoButotnPressed(_ sender: UIButton) {
        flatImageView.image = UIImage()
    }
    
    
    @IBAction func applyChangesButtonPressed(_ sender: UIButton) {
        if !checkEmptyTextFields(){
            return
        }
    
        let flat = realm.objects(Flat.self).filter("id == \(id)").first
        
        
        guard let flatImage = flatImageView.image else {return}
        Manager.shared.store(image: flatImage, forKey: "\(flat?.id ?? 0)FlatImage", withStorageType: .fileSystem)
        
        realm.beginWrite()
        flat?.name = nameTextField.text
        flat?.about = AboutTextView.text
        flat?.square = Int(squareTextField.text ?? "") ?? 0
        flat?.rooms = Int(RoomsTextField.text ?? "") ?? 0
        
        flat?.sity = city
        
        flat?.street = streetTextField.text
        flat?.BuildingNum = Int(buildingNumberTextField.text ?? "") ?? 0
        flat?.FlatNum = Int(flatTextField.text ?? "") ?? 0
        flat?.floorNum = Int(florTextField.text ?? "") ?? 0
        flat?.price = Int(priceTextField.text ?? "") ?? 0
        
        try! realm.commitWrite()
        
        presentAlertWithTitle(title: "Success", message: "Changes was applied", options: "Nice") { (option) in
            return
        }
        
    }
    
    @IBAction func DeleteButtonPressed(_ sender: UIButton) {
        realm.beginWrite()
        guard let flat = realm.objects(Flat.self).filter("id == \(id)").first else { return }
        realm.delete(flat)
        try! realm.commitWrite()
        self.navigationController?.popViewController(animated: true)
    
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func checkEmptyTextFields() -> Bool{
        if nameTextField.text == ""{
            presentAlertWithTitle(title: "No name", message: "Name field is empty", options: "close") { (option) in
                return
            }
            return false
        }
        if AboutTextView.text == ""{
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
        if RoomsTextField.text == ""{
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

extension EditOrDeleteFlatViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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

