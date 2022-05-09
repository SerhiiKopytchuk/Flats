//
//  CongratulationsViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 07.05.2022.
//

import UIKit
import SPConfetti
class CongratulationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SPConfetti.startAnimating(.fullWidthToDown, particles: [.polygon, .arc], duration: 3)
    }
    
    
    @IBAction func toMenuButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
