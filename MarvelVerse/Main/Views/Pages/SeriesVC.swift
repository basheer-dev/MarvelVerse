//
//  SeriesVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit

final class SeriesVC: UIViewController {
    private var allSeries: [Series] = []
    private var savedSeries: [SavedSeries] = []
    private var thumbnails: [Int: Data] = [:]
    private var searchTitle: String = ""
    private var globalOffset: Int = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SeriesCell.self, forCellReuseIdentifier: SeriesCell.id)
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
        savedSeries = CoreDataManager.shared.getSavedSeries()
    }
    
    // MARK: - DATA
    private func fetchData(title: String = "", offset: Int = 0) {
        var urlString = "https://gateway.marvel.com:443/v1/public/series"
        urlString += URLManager.shared.getAPIUserKeyInfo() + "&orderBy=title"
        
        if offset > 0 {
            urlString += "&offset=\(offset)&limit=20"
        }
        
        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
            urlString += "&titleStartsWith=\(title.replacingOccurrences(of: " ", with: "%20"))"
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
        let jsonDecoder = JSONDecoder()
        
        if let APIData = try? jsonDecoder.decode(AllSeries.self, from: json) {
            let APISeries = APIData.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
                
                for series in APISeries {
                    if self.allSeries.contains(where: { $0.id == series.id }) == false && series.thumbnail?.path?.contains("/image_not_available") == false {
                        self.allSeries.append(series)
                        self.tableView.insertRows(at: [IndexPath(row: self.allSeries.count - 1, section: 0)], with: .automatic)
                    } else {
                        globalOffset += 1
                    }
                }
            }
        }
    }
}

// MARK: - SAVE BUTTON EXT
extension SeriesVC: SaveButtonDelegate, SaveButtonConnectDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
        
        if let row = row {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SeriesCell else { return }
            cell.didTapSave()
        }
    }
    
    func connect(id: Int) {
        refresh(row: nil, seriesID: id)
    }
    
    private func refresh(row: Int?, seriesID: Int?) {
        getStoredData()
        
        if let row = row {
            refreshCell(at: row)
        }
        
        if let seriesID = seriesID {
            if let row = allSeries.firstIndex(where: { $0.id == seriesID }) {
                refreshCell(at: row)
            }
        }
    }
    
    private func refreshCell(at row: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SeriesCell else { return }
        cell.didTapSave()
    }
}


// MARK: - APISEARCH EXT
extension SeriesVC: APIDataSearch {
    func didSearchFor(title: String) {
        clearData()
        searchTitle = title
        fetchData(title: searchTitle)
    }
    
    private func clearData() {
        thumbnails.removeAll()
        allSeries.removeAll()
        tableView.reloadData()
    }
}


// MARK: - TABLEVIEW EXT
extension SeriesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesCell.id, for: indexPath) as? SeriesCell else { fatalError() }
        cell.set(series: allSeries[indexPath.row], isSaved: savedSeries.contains(where: { $0.id == allSeries[indexPath.row].id }))
        cell.delegate = self
        
        /// Getting the thumbnail image
        cell.activityIndicator.startAnimating()
        cell.seriesImageView.image = .none
        
        if thumbnails[allSeries[indexPath.row].id] != nil {
            cell.activityIndicator.stopAnimating()
            cell.seriesImageView.image = UIImage(data: thumbnails[allSeries[indexPath.row].id]!)
        } else {
            ModelImageManager.shared.getImageData(for: allSeries[indexPath.row].thumbnail) {
                [weak self] data in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.seriesImageView.image = UIImage(data: data)
                    
                    if self.allSeries.count > indexPath.row {
                        self.thumbnails[self.allSeries[indexPath.row].id] = data
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = SeriesDetailsVC()
        dest.set(series: allSeries[indexPath.row], rowID: indexPath.row, isSaved: savedSeries.contains(where: { $0.id == allSeries[indexPath.row].id }))
        dest.delegate = self
        
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == allSeries.count - 1 {
            fetchData(title: searchTitle, offset: allSeries.count + globalOffset)
        }
    }
}
