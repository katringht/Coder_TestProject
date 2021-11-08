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
    let service = NetworkingService.shared
    static var nSelectedSegmentIndex : Int = 0
    let titles = ["Все", "IOS", "Android", "Design", "Analytics", "Management",  "QA", "Back_office", "Frontend", "HR", "PR", "Support", "Backend"]
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
        
        updateView()
    }
    
// MARK: update view
    func updateView() {
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let data):
                self?.users = data.sorted(by: { $0.lastName < $1.lastName})
            case .Error(let message):
                DispatchQueue.main.async {
                    print(message)
                }
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func filterButtonSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewController(identifier: "FilterViewController")
        present(filterVC, animated: true)
    }
    
// MARK: refresh control for tableview
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
        updateView()
        refreshControl.endRefreshing()
    }
    
// MARK: set up segmented Control
    func setUpSegmented() {
        segmentedView.buttonTitles = titles
        segmentedView.tableView = tableView
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
        if MainViewController.nSelectedSegmentIndex == 0 {
            return users.count
        } else {
            let category = users.filter { $0.department == titles[MainViewController.nSelectedSegmentIndex].lowercased()}
            return category.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user: User
        if MainViewController.nSelectedSegmentIndex == 0 {
            user = users[indexPath.row]
            cell.userNameLabel.text = "\(user.firstName) \(user.lastName)"
            cell.userTagLabel.text = user.userTag.lowercased()
            cell.userDepartmentLabel.text = user.position
            cell.userImageView.loadImageUsingUrl(urlString: user.avatarUrl)
        } else {
            let category = users.filter { $0.department == titles[MainViewController.nSelectedSegmentIndex].lowercased() }
            user = category[indexPath.row]
            cell.userNameLabel.text = "\(user.firstName) \(user.lastName)"
            cell.userTagLabel.text = user.userTag.lowercased()
            cell.userDepartmentLabel.text = user.position
            cell.userImageView.loadImageUsingUrl(urlString: user.avatarUrl)
        }
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
        let user = users[indexPath.row]
        detailVC.username = "\(user.firstName) \(user.lastName)"
        detailVC.usertag = user.userTag.lowercased()
        detailVC.imageurl = user.avatarUrl
        detailVC.userposition = user.position
        detailVC.phoneInfo = user.phone.replacingOccurrences(of: "-", with: "")
        detailVC.birthdayInfo = user.birthday.replacingOccurrences(of: "-", with: ".")
        show(detailVC, sender: self)
    }
}
