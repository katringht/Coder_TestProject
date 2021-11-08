//
//  DetailTableViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 03.11.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var infoUserDepartmentLabel: UILabel!
    @IBOutlet weak var infoUserTagLabel: UILabel!
    @IBOutlet weak var infoUserNameLabel: UILabel!
    @IBOutlet weak var infoUserImageView: UIImageView!
    var birthdayInfo: String?
    var phoneInfo: String?
    var username: String?
    var usertag: String?
    var userposition: String?
    var imageurl: String?
    var age: String?
    var info: [InfoUser] = []
    
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.dataSource = self
        infoTableView.delegate = self
        setUpTableViewCell()
        infoUserDepartmentLabel.text = userposition
        infoUserNameLabel.text = username
        infoUserTagLabel.text = usertag
        infoUserImageView.loadImageUsingUrl(urlString: imageurl!)
        infoUserImageView.layer.cornerRadius = 40
    }
    
    func setUpTableViewCell() {
        let phoneImage = UIImage(systemName: "phone")
        let starImage = UIImage(systemName: "star")
        let birthday = dateFormatter.date(from: birthdayInfo!)
        let timeInterval = birthday?.timeIntervalSinceNow
        let age = abs(Int(timeInterval! / 31556926.0))
        
        info = [InfoUser(icon: starImage!, mainInfo: birthdayInfo!, extraInfo: "\(age) года"), InfoUser(icon: phoneImage!, mainInfo: phoneInfo!, extraInfo: "")]
    }
    
    @IBAction func backToButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    } 
}

// MARK: - Table view
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InformationTableViewCell
        let i = info[indexPath.row]
        cell.informationLabel.text = i.mainInfo
        cell.icon.image = i.icon
        cell.deteilInfoLabel.text = i.extraInfo
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 1 {
            if let url = NSURL(string: "tel://" + self.phoneInfo!),
               UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
    }
}
