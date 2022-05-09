//
//  MyFriendsTableViewCell.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 19.04.2022.
//

import UIKit

protocol MyFriendsTableViewCellDelegate: AnyObject{
    func removeButtonPressed(userId:Int)
}

class MyFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var userId:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate:MyFriendsTableViewCellDelegate?
    
    

    @IBAction func removeButtonPressed(_ sender: UIButton) {
        delegate?.removeButtonPressed(userId: userId)
    }
    
}
