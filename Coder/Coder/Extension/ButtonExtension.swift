//
//  ButtonExtension.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 01.11.2021.
//

import UIKit

extension UIButton {
    
    func selectedButton() {
        self.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
    }
    
    func unselectedButton() {
        self.setImage(UIImage(systemName: "circle"), for: .normal)
    }
}
