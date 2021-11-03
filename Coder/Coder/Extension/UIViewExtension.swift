//
//  UIViewExtension.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 02.11.2021.
//

import UIKit

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat, y: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: y - 3, width: width, height: 3)
        self.layer.addSublayer(border)
    }
}
