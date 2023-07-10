//
//  DropDownMenuVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit

protocol DropDownMenuDelegate {
    func didTapMenuItem(named name: String)
}

class DropDownMenuVC: UIViewController {
    var items: [String] = []
    var delegate: DropDownMenuDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownMenuItemContainer")
        
        return tableView
    }()

    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize.height = tableView.contentSize.height
        self.preferredContentSize.width = 200
    }

    override func viewWillDisappear(_ animated: Bool) {
        tableView.removeObserver(self, forKeyPath: "contentSize")

    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}


// MARK: - TABLEVIEW EXT
extension DropDownMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownMenuItemContainer", for: indexPath)
        var cellInfo = cell.defaultContentConfiguration()
        cellInfo.text = items[indexPath.row]
        
        cell.contentConfiguration = cellInfo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: false)
        delegate?.didTapMenuItem(named: items[indexPath.row])
    }
}
