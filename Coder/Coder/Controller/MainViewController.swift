//
//  ViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 01.11.2021.
//

import UIKit

class MainViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedView: CustomSegmentedControl!
    @IBOutlet weak var searchField: UITextField!
    let filterButton = UIButton(type: .custom)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        textFieldSetup()
        setUpSegmented()
        addRefreshControl()
        filterButton.addTarget(self, action: #selector(filterButtonSetup), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func filterButtonSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewController(identifier: "FilterViewController")
        present(filterVC, animated: true)
    }
    
    // add refresh control for tableview
    func addRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "purpleCustom")!
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
    }
    
    // set up segmented Control
    func setUpSegmented() {
        let titles = ["Все", "Designers", "Analysts", "Managers", "IOS", "Android", "QA", "Back Office", "Frontend", "HR", "PR", "Support", "Backend"]
        segmentedView.buttonTitles = titles
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

// MARK: - Table view extensions

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController

        show(detailVC, sender: self)
    }
}
