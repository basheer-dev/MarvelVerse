//
//  SavedEventsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit


final class SavedEventsVC: UIViewController {
    private var events: [Event] = []
    private var savedEvents: [SavedEvent] = []
    private var thumbnails: [Int: Data] = [:]
    
    var delegate: SaveButtonConnectDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - VLD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        getStoredData()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        tableView.tableFooterView = createTableViewFooter()
        
        view.addSubview(tableView)
    }
    
    private func createTableViewFooter() -> UIView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        activityIndicator.startAnimating()
        activityIndicator.color = .systemRed
        
        return activityIndicator
    }
    
    // MARK: - COREDATA
    private func getStoredData() {
        savedEvents = CoreDataManager.shared.getSavedEvents()
    }
    
    // MARK: - DATA
    private func fetchData() {
        for event in savedEvents {
            var urlString = "https://gateway.marvel.com:443/v1/public/events/\(event.id)"
            urlString += URLManager.shared.getAPIUserKeyInfo()
            
            DispatchQueue.global(qos: .userInteractive).async {
                [weak self] in
                
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        // Ok to parse
                        self?.parseJSON(json: data)
                    }
                }
            }
        }
    }
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Events.self, from: json) {
            if let APIEvent = APIData.data.results.first {
                
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    
                    self.events.append(APIEvent)
                    self.tableView.insertRows(at: [IndexPath(row: self.events.count - 1, section: 0)], with: .automatic)
                }
            }
        }
    }
}


// MARK: - SAVE BUTTON EXT
extension SavedEventsVC: SaveButtonDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
        
        if let itemID = itemID {
            delegate?.connect(id: itemID)
        }
        
        if let row = row {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EventCell else { return }
            cell.didTapSave()
        }
    }
}


// MARK: - TABLEVIEW EXT
extension SavedEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.id, for: indexPath) as? EventCell else { fatalError() }
        cell.set(event: events[indexPath.row], isSaved: savedEvents.contains(where: { $0.id == events[indexPath.row].id }))
        cell.delegate = self
        
        /// Getting the thumbnail image
        cell.activityIndicator.startAnimating()
        cell.thumbNailImageView.image = .none
        
        if thumbnails[events[indexPath.row].id] != nil {
            cell.activityIndicator.stopAnimating()
            cell.thumbNailImageView.image = UIImage(data: thumbnails[events[indexPath.row].id]!)
        } else {
            ModelImageManager.shared.getImageData(for: events[indexPath.row].thumbnail) {
                [weak self] data in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.thumbNailImageView.image = UIImage(data: data)
                    
                    if self.events.count > indexPath.row {
                        self.thumbnails[self.events[indexPath.row].id] = data
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = EventDetailsVC()
        dest.set(event: events[indexPath.row], rowID: indexPath.row, isSaved: savedEvents.contains(where: { $0.id == events[indexPath.row].id }))
        dest.delegate = self
        
        navigationController?.pushViewController(dest, animated: true)
    }
}
