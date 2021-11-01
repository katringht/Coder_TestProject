//
//  ViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 01.11.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    let filterButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSetup()
        filterButton.addTarget(self, action: #selector(filterButtonSetup), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func filterButtonSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewController(identifier: "FilterViewController")
        present(filterVC, animated: true)

    }
    
    // MARK: Text Field Settings
    func textFieldSetup() {
        searchField.layer.cornerRadius = 10
        // left view
        let leftViewField = UIImageView()
        let magnifyingglassImage = UIImage(systemName: "magnifyingglass")
        searchField.leftViewMode = .always
        leftViewField.image = magnifyingglassImage
        leftViewField.frame = CGRect(x: 10, y: 5, width: 21, height: 20)
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width:  30, height:  30))
        iconContainerView.addSubview(leftViewField)
        searchField.leftView = iconContainerView
        
        //right view
        let sliderImage = UIImage(systemName: "slider.horizontal.3")
        let iconContainerView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width:  30, height:  20))
        iconContainerView2.addSubview(filterButton)
        filterButton.setImage(sliderImage, for: .normal)
        filterButton.sizeToFit()
        searchField.rightViewMode = .unlessEditing
        searchField.rightView = iconContainerView2
        
        searchField.clearButtonMode = .whileEditing
        
    }


}

