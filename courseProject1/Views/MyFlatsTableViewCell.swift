//
//  MyFlatsTableViewCell.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 26.02.2022.
//

import UIKit

class MyFlatsTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var flatImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuration(name:String, price:String, image:UIImage){
        mainLabel.text = name
        priceLabel.text = price
        flatImageView?.image = image
    }

}
