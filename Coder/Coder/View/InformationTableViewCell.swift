//
//  InformationTableViewCell.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 03.11.2021.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var deteilInfoLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
