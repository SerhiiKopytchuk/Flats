//
//  ChooseFlatOrStudioViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import UIKit

class ChooseFlatOrStudioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flatButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "CreateFlatViewController") as! CreateFlatViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func studioButtonPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "CreateStudioViewController") as! CreateStudioViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
