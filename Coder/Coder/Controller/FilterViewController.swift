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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "FILTER") {
            alphabetFilterButton.selectedButton()
            birthdayFilterButton.unselectedButton()
        } else {
            alphabetFilterButton.unselectedButton()
            birthdayFilterButton.selectedButton()
        }
    }

    @IBAction func closeScreenButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func alphabetFilter(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "FILTER")
        alphabetFilterButton.selectedButton()
        birthdayFilterButton.unselectedButton()
        NotificationCenter.default.post(name: .reload, object: nil)
        self.dismiss(animated: true)
    }
    
    @IBAction func birthdayFilter(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "FILTER")
        alphabetFilterButton.unselectedButton()
        birthdayFilterButton.selectedButton()
        NotificationCenter.default.post(name: .reload, object: nil)
        self.dismiss(animated: true)
    }
}
