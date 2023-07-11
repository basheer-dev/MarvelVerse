//
//  StoriesVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit

final class EventsVC: UIViewController {
    private var events: [Event] = []
    private var savedEvents: [SavedEvent] = []
    private var thumbnails: [Int: Data] = [:]
    private var searchTitle: String = ""
    private var globalOffset: Int = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()

    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        fetchData(title: searchTitle)
        getStoredData()
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
    private func fetchData(title: String = "", offset: Int = 0) {
        var urlString = "https://gateway.marvel.com:443/v1/public/events"
        urlString += URLManager.shared.getAPIUserKeyInfo() + "&orderBy=name"
        
        if offset > 0 {
            urlString += "&offset=\(offset)&limit=20"
        }
        
        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
            
            if title.lowercased() == "spider man" {
                urlString += "&nameStartsWith=\(title.replacingOccurrences(of: " ", with: "-§"))"
            } else {
                urlString += "&nameStartsWith=\(title.replacingOccurrences(of: " ", with: "%20"))"
            }
        }
        
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
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Events.self, from: json) {
            let APIEvents = APIData.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
                
                for event in APIEvents {
                    if self.events.contains(where: { $0.id == event.id }) == false && event.thumbnail?.path?.contains("/image_not_available") == false {
                        self.events.append(event)
                        self.tableView.insertRows(at: [IndexPath(row: self.events.count - 1, section: 0)], with: .automatic)
                    } else {
                        globalOffset += 1
                    }
                }
            }
        }
    }
}


// MARK: - SAVE BUTTON EXT
extension EventsVC: SaveButtonDelegate, SaveButtonConnectDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        refresh(row: row, eventID: nil)
    }
    
    func connect(id: Int) {
        refresh(row: nil, eventID: id)
    }
    
    private func refresh(row: Int?, eventID: Int?)  {
        getStoredData()
        
        if let row = row {
            refreshCell(at: row)
        }
        
        if let eventID = eventID {
            if let row = events.firstIndex(where: { $0.id == eventID }) {
                refreshCell(at: row)
            }
        }
    }
    
    private func refreshCell(at row: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EventCell else { return }
        cell.didTapSave()
    }
}


// MARK: - APISEARCH EXT
extension EventsVC: APIDataSearch {
    
    func didSearchFor(title: String) {
        clearData()
        searchTitle = title
        fetchData(title: searchTitle)
    }
    
    private func clearData() {
        thumbnails.removeAll()
        events.removeAll()
        tableView.reloadData()
    }
}


// MARK: - TABLEVIEW EXT
extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == events.count - 1 {
            fetchData(title: searchTitle, offset: events.count + globalOffset)
        }
    }
}
