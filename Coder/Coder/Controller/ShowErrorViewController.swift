//
//  ShowErrorViewController.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 06.11.2021.
//

import UIKit

class ShowErrorViewController: UIViewController {

    private lazy var errorView: ErrorView = {
        let errorV = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as? ErrorView
        errorV?.set(title: "Какой-то сверхразум все сломал", subtitle: "Постараемся быстро починить", myerrorIcon: "flyingsaucer", button: true)
        return errorV!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(errorView)
        errorView.center = view.center
        errorView.errorRefreshButton.addTarget(self, action: #selector(tryEgainButton(_:)), for: .touchUpInside)
    }

    @objc func tryEgainButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
