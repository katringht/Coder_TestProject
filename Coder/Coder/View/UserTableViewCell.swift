//
//  UserTableViewCell.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 03.11.2021.
//

import UIKit
import SkeletonView

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userTagLabel: UILabel!
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    static let cellID = "UserCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 40
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
