//
//  ErrorView.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 11.11.2021.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet weak var errorBack: UIView!
    @IBOutlet weak var errorRefreshButton: UIButton!
    @IBOutlet weak var errorSublable: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorIcon: UIImageView!
    
    var title: String?
    var subtitle: String?
    
    func set(title: String, subtitle: String, myerrorIcon: String, button: Bool) {
        errorLabel.text = title
        errorSublable.text = subtitle
        let myImage = UIImage(named: myerrorIcon)
        errorIcon.image = myImage
        
        if button == false {
            errorRefreshButton.isHidden = true
        } else {
            errorRefreshButton.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
