//
//  MainVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 01/07/2023.
//

import UIKit

protocol APIDataSearch {
    func didSearchFor(title: String)
}

final class MainVC: UIViewController {
    var delegate: APIDataSearch?
    
    private let comicsVC: UIViewController = ComicsVC()
    private let seriesVC: UIViewController = SeriesVC()
    private let eventsVC: UIViewController = EventsVC()
    
    private var pageContentView: UIView?
    private var isDropDownMenuActive: Bool = false
    private var isSideMenuActive: Bool = false
    
    enum Page: String, CaseIterable {
        case comics = "Comics"
        case series = "Series"
        case Events = "Events"
        case characters = "Characters"
    }
    
    private let dropDownMenu: UIViewController = {
        let x = UIViewController()
        
        return x
    }()
    
    private let sideMenu: UIView = {
        let menu = UIView()
        menu.backgroundColor = .secondarySystemBackground
        
        menu.clipsToBounds = true
        
        return menu
    }()
    
    private lazy var menuTable: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .secondarySystemBackground
        
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.circle"), style: .plain, target: self, action: #selector(toggleDropDownMenu))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(toggleSideMenu))
        
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
//        let comicsVC = ComicsVC()
        delegate = self.comicsVC as? any APIDataSearch
        
        addChild(comicsVC)
        view.addSubview(comicsVC.view)
        
        pageContentView = comicsVC.view
        title = "Comics"
        
        sideMenu.frame = CGRect(x: -(view.frame.width - 100), y: view.frame.origin.y, width: view.frame.width - 100, height: view.frame.height)
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
                self.view.subviews.first?.isUserInteractionEnabled = false
                self.sideMenu.frame.origin.x = 0
                self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: self.view.frame.width - 100, y: 0)
                self.pageContentView?.frame.origin.x = self.view.frame.width - 100
            } else {
                self.view.subviews.first?.isUserInteractionEnabled = true
                self.sideMenu.frame.origin.x = -(self.view.frame.width - 100)
                self.navigationController?.navigationBar.transform = .identity
                self.pageContentView?.frame.origin.x = 0
            }
        }
    }
    
    @objc func toggleDropDownMenu(_ sender: UIBarButtonItem) {
        let dest = DropDownMenuVC()
        dest.delegate = self
        
        dest.modalPresentationStyle = .popover
        Page.allCases.forEach {
            page in
            dest.items.append(page.rawValue)
        }
        
        dest.popoverPresentationController?.permittedArrowDirections = .up
        dest.popoverPresentationController?.sourceView = self.view
        dest.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width - 25, y: 100, width: 10, height: 10)
        dest.popoverPresentationController?.delegate = self
        
        present(dest, animated: true, completion: nil)
    }
}


extension MainVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


// MARK: - DROP DOWN MENU EXT
extension MainVC: DropDownMenuDelegate {
    func didTapMenuItem(named name: String) {
        switch name {
        case Page.series.rawValue:
            let dest = SavedSeriesVC()
//            dest.MainSeriesVC = seriesVC
            
            navigationController?.pushViewController(dest, animated: true)
            
        case Page.Events.rawValue:
            let dest = SavedEventsVC()
//            dest.MainEventsVC = eventsVC
            
            navigationController?.pushViewController(dest, animated: true)
            
        default:
            let dest = SavedComicsVC()
            dest.delegate = comicsVC as? any SaveButtonConnectDelegate
            
            navigationController?.pushViewController(dest, animated: true)
        }
    }
}


// MARK: - SEARCH BAR EXT
extension MainVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.placeholder = searchText.trimmingCharacters(in: .whitespaces).isEmpty ? "Search" : searchText
        delegate?.didSearchFor(title: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.placeholder = "Search"
        delegate?.didSearchFor(title: "")
    }
}


// MARK: - TABLEVIEW EXT
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Page.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellInfo = cell.defaultContentConfiguration()
        
        cellInfo.text = Page.allCases[indexPath.row].rawValue
        cellInfo.textProperties.color = .label
        cellInfo.textProperties.font = .systemFont(ofSize: 15, weight: .bold)
        
        cell.contentConfiguration = cellInfo
        cell.backgroundColor = .secondarySystemBackground
        
        if title == Page.comics.rawValue && cellInfo.text == Page.comics.rawValue {
            cell.backgroundColor = .systemRed
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dest = Page.allCases[indexPath.row].rawValue
        
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
        let row: Int
        
        switch title {
        case Page.series.rawValue:
            row = 1
            dest = seriesVC
        case Page.characters.rawValue:
            row = 3
            dest = CharactersVC()
        case Page.Events.rawValue:
            row = 2
            dest = eventsVC
        default:
            row = 0
            dest = comicsVC
        }
        
        delegate = dest as? any APIDataSearch
        
        searchController.searchBar.text = ""
        searchController.searchBar.placeholder = "Search"
        
        addChild(dest)
        view.insertSubview(dest.view, at: 0)
        
        pageContentView = dest.view
        pageContentView?.frame.origin.x = view.frame.width - 100
        
        isSideMenuActive = false
        showHideSideMenu()
        
        for cell in menuTable.visibleCells {
            cell.backgroundColor = .clear
        }
        
        menuTable.cellForRow(at: IndexPath(row: row, section: 0))?.backgroundColor = .systemRed
        self.title = title
    }
}
