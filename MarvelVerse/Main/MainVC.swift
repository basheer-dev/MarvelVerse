//
//  MainVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 01/07/2023.
//

import UIKit

final class MainVC: UIViewController {
    private var pageContentView: UIView?
    private let comicsVC = ComicsVC()
    private var isSideMenuActive: Bool = false
    
    enum Pages: String, CaseIterable {
        case comics = "Comics"
        case series = "Series"
        case characters = "Characters"
        case stories = "Stories"
        
    }
    
    private let sideMenu: UIView = {
        let menu = UIView()
        menu.backgroundColor = .systemRed
        
        menu.layer.cornerRadius = 10
        menu.clipsToBounds = true
        
        return menu
    }()
    
    private lazy var menuTable: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemRed
        
        return tableView
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        
        button.configuration = .filled()
        button.configuration?.title = "Bahseer"
        return button
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(test))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet.indent"), style: .plain, target: self, action: #selector(toggleSideMenu))
        
        handleSwipes()
        configureSubviews()
    }
    
    // MARK: - USER SWIPE & SUBVIEWS
    private func handleSwipes() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUserSwipes))
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUserSwipes))
        
        rightSwipeGesture.direction = directions[0]
        leftSwipeGesture.direction = directions[1]
        
        view.addGestureRecognizer(rightSwipeGesture)
        view.addGestureRecognizer(leftSwipeGesture)
    }
    
    private func configureSubviews() {
        let comicsVC = ComicsVC()
        addChild(comicsVC)
        view.addSubview(comicsVC.view)
        pageContentView = comicsVC.view
        title = "Comics"
        
        sideMenu.frame = CGRect(x: -(view.frame.width - 100), y: 0, width: view.frame.width - 100, height: view.frame.height)
        menuTable.frame = sideMenu.bounds
        sideMenu.addSubview(menuTable)
        view.addSubview(sideMenu)
    }
    
    // MARK: - ACTIONS
    @objc private func toggleSideMenu() {
        isSideMenuActive.toggle()
        showHideSideMenu()
    }
    
    @objc private func handleUserSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            guard isSideMenuActive == true else { return }
            isSideMenuActive = false
        } else if sender.direction == .right {
            guard isSideMenuActive == false else { return }
            isSideMenuActive = true
        }
        
        showHideSideMenu()
    }
    
    private func showHideSideMenu() {
        UIView.animate(withDuration: 0.2) {
            if self.isSideMenuActive == true {
                self.sideMenu.frame.origin.x = 0
                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: self.view.frame.width - 100, y: 0)
                self.pageContentView?.frame.origin.x = self.view.frame.width - 100
            } else {
                self.sideMenu.frame.origin.x = -(self.view.frame.width - 100)
                self.navigationController?.navigationBar.transform = .identity
                self.pageContentView?.frame.origin.x = 0
            }
        }
    }
    
    @objc func test() {}
}


// MARK: - TABLEVIEW EXT
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Pages.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellInfo = cell.defaultContentConfiguration()
        
        cellInfo.text = Pages.allCases[indexPath.row].rawValue
        cellInfo.textProperties.color = .systemBackground
        cellInfo.textProperties.font = .systemFont(ofSize: 15, weight: .bold)
        
        cell.contentConfiguration = cellInfo
        cell.backgroundColor = .systemRed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dest = Pages.allCases[indexPath.row].rawValue
        switchView(to: dest)
    }
    
    func switchView(to title: String) {
        // Checking if the user tried to open an already opened view controller
        guard self.title != title else { return }
        
        // Clearing out previous view controllers
        children.first?.removeFromParent()
        view.subviews.first?.removeFromSuperview()
        
        // Adding the new view controller
        let dest: UIViewController
        
        switch title {
        case Pages.series.rawValue:
            dest = SeriesVC()
        case Pages.characters.rawValue:
            dest = CharactersVC()
        case Pages.stories.rawValue:
            dest = StoriesVC()
        default:
            dest = ComicsVC()
        }
        
        addChild(dest)
        view.insertSubview(dest.view, at: 0)
        pageContentView = dest.view
        pageContentView?.frame.origin.x = view.frame.width - 100
        
        self.title = title
    }
}
