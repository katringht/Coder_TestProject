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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.dataSource = self
    }
    @IBAction func backToButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    } 
}

// MARK: - Table view data source
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InformationTableViewCell
//        let i = info[indexPath.row]
//        cell.informationLabel.text = i.mainInfo
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
