//
//  CustomSegmentedControl.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 02.11.2021.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    var buttonTitles: [String]!
    private var buttons : [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = .gray
    var selectorViewColor: UIColor = UIColor(named: "purpleCustom")!
    var selectorTextColor: UIColor = .black

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    private func updateView() {
        createButton()
        setUpStackView()
    }
    
    @objc func buttonAction(sender: UIButton) {
        for btn in buttons {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                btn.addBottomBorderWithColor(color: selectorViewColor, width: btn.frame.size.width, y: frame.size.height)
                btn.setTitleColor(selectorTextColor, for: .normal)
            } else {
                btn.addBottomBorderWithColor(color: .white, width: btn.frame.size.width, y: frame.size.height)
                btn.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    // create a Button
    private func createButton() {
        buttons = [UIButton]()
        //remove any element in buttons and remove all subviews inside our view
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].addBottomBorderWithColor(color: selectorViewColor, width: 80, y: frame.size.height)
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    // create a StackView
    private func setUpStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: .zero, height: 50)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stack)
        addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
}
