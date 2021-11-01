//
//  FilterViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 01.11.2021.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var alphabetFilterButton: UIButton!
    @IBOutlet weak var birthdayFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphabetFilterButton.selectedButton()
        birthdayFilterButton.unselectedButton()
    }

    @IBAction func closeScreenButton(_ sender: Any) {
        dismiss(animated: true)
        print("ff")
    }
    
    @IBAction func alphabetFilter(_ sender: Any) {
        alphabetFilterButton.selectedButton()
        birthdayFilterButton.unselectedButton()
    }
    
    @IBAction func birthdayFilter(_ sender: Any) {
        alphabetFilterButton.unselectedButton()
        birthdayFilterButton.selectedButton()
    }
}
