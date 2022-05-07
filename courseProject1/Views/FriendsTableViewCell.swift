//
//  FriendsTableViewCell.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 19.04.2022.
//

import UIKit

protocol FriendsTableViewCellDelegate: AnyObject{
    func addButtonPressed(userId:Int, name:String)
}

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var userId:Int = 0
    
    weak var delegate: FriendsTableViewCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.addButtonPressed(userId:userId, name: nameLabel.text ?? "")
    }
    

}
