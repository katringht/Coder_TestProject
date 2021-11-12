//
//  ViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 01.11.2021.
//

import UIKit
import SkeletonView

class MainViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedView: CustomSegmentedControl!
    @IBOutlet weak var searchField: UITextField!
    let filterButton = UIButton(type: .custom)
    private let refreshControl = UIRefreshControl()
    let service = NetworkingService.shared
    static var nSelectedSegmentIndex : Int = 0
    let titles = ["Все", "IOS", "Android", "Design", "Analytics", "Management",  "QA", "Back_office", "Frontend", "HR", "PR", "Support", "Backend"]
    var filteredUsers = [User]()
    var isSearching = false
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var dataWasLoaded = false
    var isDataFiltred = false
    private lazy var errorView: ErrorView = {
        let errorV = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as? ErrorView
        errorV?.set(title: "Мы никого не нашли", subtitle: "Попробуй скорректировать запрос", myerrorIcon: "magnifyingglass", button: false)
        return errorV!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
        textFieldSetup()
        setUpSegmented()
        addRefreshControl()
        updateView()
        
        filterButton.addTarget(self, action: #selector(filterButtonSetup), for: .touchUpInside)
        searchField.addTarget(self, action: #selector(searchRecord), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        UserDefaults.standard.set(false, forKey: "FILTER")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataWasLoaded = true
    }
    
    // MARK: Update view
    func updateView() {
        service.getDataWith { [weak self] result in
            switch result {
            case .Success(let data):
                if !UserDefaults.standard.bool(forKey: "FILTER") {
                    self?.users = data.sorted(by: { $0.lastName < $1.lastName})
                    self?.isDataFiltred = false
                } else {
                    self?.users = data.sorted(by: { (self?.daysUntil(birthday: $0.birthday))! < (self?.daysUntil(birthday: $1.birthday))!})
                    self?.isDataFiltred = true
                    
                }
            case .Error(let message):
                DispatchQueue.main.async {
                    self?.showError()
                    print(message)
                }
            }
        }
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        updateView()
    }
    
    func showError() {
        let vc = ShowErrorViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Filter set up
    @objc func filterButtonSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewController(identifier: "FilterViewController")
        present(filterVC, animated: true)
    }
    
    // MARK: Date filter
    func daysUntil(birthday: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let formatBirth = formatter.date(from: birthday)
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let date = cal.startOfDay(for: formatBirth!)
        let components = cal.dateComponents([.day, .month], from: date)
        let nextDate = cal.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        return cal.dateComponents([.day], from: today, to: nextDate ?? today).day ?? 0
    }
    
    // MARK: Refresh control for tableview
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
    
    // MARK: Set up segmented Control
    func setUpSegmented() {
        segmentedView.buttonTitles = titles
        segmentedView.tableView = tableView
    }
    
    // MARK: Search Text Field Settings
    @objc func searchRecord(sender: UITextField) {
        self.filteredUsers.removeAll()
        let searchData = searchField.text?.count
        if searchData != 0 {
            isSearching = true
            var i = 0
            for user in users {
                if let userToSearch = searchField.text {
                    let range = user.firstName.lowercased().range(of: userToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    let rangeLastName = user.lastName.lowercased().range(of: userToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    let rangeUserTag = user.userTag.lowercased().range(of: userToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil || rangeLastName != nil || rangeUserTag != nil {
                        self.filteredUsers.append(user)
                    }
                }
                i += 1
            }
        } else {
            filteredUsers = users
            isSearching = false
        }
        tableView.reloadData()
        
        if filteredUsers.count == 0 {
            errorView.center = tableView.center
            tableView.backgroundView = errorView

        } else {
            tableView.backgroundView = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
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

extension MainViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return UserTableViewCell.cellID
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataWasLoaded == false {
            return 10
        } else {
            if MainViewController.nSelectedSegmentIndex == 0 {
                if isSearching {
                    return filteredUsers.count
                } else {
                    return users.count
                }
            } else {
                if isSearching {
                    let category = filteredUsers.filter { $0.department == titles[MainViewController.nSelectedSegmentIndex].lowercased()}
                    return category.count
                } else {
                    let category = users.filter { $0.department == titles[MainViewController.nSelectedSegmentIndex].lowercased()}
                    return category.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellID, for: indexPath) as! UserTableViewCell
        cell.isSkeletonable = true
        cell.showAnimatedGradientSkeleton()
        cell.userBirthday.isHidden = true
        let user: User
        if dataWasLoaded == true {
            cell.hideSkeleton()
            cell.stopSkeletonAnimation()
            if MainViewController.nSelectedSegmentIndex == 0 {
                if isSearching {
                    user = self.filteredUsers[indexPath.row]
                } else {
                    user = self.users[indexPath.row]
                }
            } else {
                if isSearching {
                    let category = self.filteredUsers.filter { $0.department == self.titles[MainViewController.nSelectedSegmentIndex].lowercased() }
                    user = category[indexPath.row]
                } else {
                    let category = self.users.filter { $0.department == self.titles[MainViewController.nSelectedSegmentIndex].lowercased() }
                    user = category[indexPath.row]
                }
            }
            cell.userNameLabel.text = "\(user.firstName) \(user.lastName)"
            cell.userTagLabel.text = user.userTag.lowercased()
            cell.userDepartmentLabel.text = user.position
            cell.userImageView.loadImageUsingUrl(urlString: user.avatarUrl)
            let birth = user.birthday.replacingOccurrences(of: "-", with: ".")
            cell.userBirthday.text = String(birth.suffix(5))
            if isDataFiltred == true {
                cell.userBirthday.isHidden = false
            }
            
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
        let user: User
        if isSearching {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        detailVC.username = "\(user.firstName) \(user.lastName)"
        detailVC.usertag = user.userTag.lowercased()
        detailVC.imageurl = user.avatarUrl
        detailVC.userposition = user.position
        detailVC.phoneInfo = user.phone.replacingOccurrences(of: "-", with: "")
        detailVC.birthdayInfo = user.birthday.replacingOccurrences(of: "-", with: ".")
        show(detailVC, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
