//
//  SavedSeriesVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit

class SavedSeriesVC: UIViewController {
    private var allSeries: [Series] = []
    private var savedSeries: [SavedSeries] = []
    private var thumbnails: [Int: Data] = [:]
    
    var delegate: SaveButtonConnectDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SeriesCell.self, forCellReuseIdentifier: SeriesCell.id)
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
        savedSeries = CoreDataManager.shared.getSavedSeries()
    }
    
    // MARK: - DATA
    private func fetchData() {
        for series in savedSeries {
            var urlString = "https://gateway.marvel.com:443/v1/public/series/\(series.id)"
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
        let jsonDecoder = JSONDecoder()
        
        if let APIData = try? jsonDecoder.decode(AllSeries.self, from: json) {
            if let APISeries = APIData.data.results.first {
                
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    
                    self.allSeries.append(APISeries)
                    self.tableView.insertRows(at: [IndexPath(row: self.allSeries.count - 1, section: 0)], with: .automatic)
                }
                
            }
        }
    }
}


// MARK: - SAVE BUTTON EXT
extension SavedSeriesVC: SaveButtonDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
        
        if let  itemID = itemID {
            delegate?.connect(id: itemID)
        }
        
        if let row = row {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SeriesCell else { return }
            cell.didTapSave()
        }
    }
}


// MARK: - TABLEVIEW EXT
extension SavedSeriesVC: UITableViewDelegate, UITableViewDataSource {
    
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
}

