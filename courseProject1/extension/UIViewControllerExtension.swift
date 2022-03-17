//
//  UIViewControllerExtension.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 11.03.2022.
//

import Foundation
import UIKit


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = UIImage()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }
        handlePickedImage(chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePickedImage(_ image: UIImage) {
    }
}
