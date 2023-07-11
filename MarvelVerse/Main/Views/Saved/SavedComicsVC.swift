//
//  SavedComicsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit

protocol SaveButtonConnectDelegate {
    func connect(id: Int)
}

final class SavedComicsVC: UIViewController {
    private var comics: [Comic] = []
    private var savedComics: [SavedComic] = []
    private var thumbnails: [Int: Data] = [:]
    
    var delegate: SaveButtonConnectDelegate?
    
    enum TableViewFooterState {
        case loading
        case done
        case empty
    }
            
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ComicCell.self, forCellReuseIdentifier: ComicCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        activityIndicator.startAnimating()
        activityIndicator.color = .systemRed
        
        return activityIndicator
    }()
    
    private lazy var doneImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "checkmark.circle")
        view.tintColor = .systemRed
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 25)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "bookmark.slash")
        view.tintColor = .systemRed
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 25)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Saved Comics"
        
        getStoredData()
        fetchData()
        configureSubviews()
    }
    
    func configureSubviews() {
        tableView.frame = view.bounds
        tableView.tableFooterView = createTableViewFooter(state: .loading)
        
        if savedComics.isEmpty {
            tableView.tableFooterView = createTableViewFooter(state: .empty)
        }
        
        view.addSubview(tableView)
    }
    
    private func createTableViewFooter(state: TableViewFooterState) -> UIView {
        switch state {
        case .done:
            return doneImageView
        case .empty:
            tableView.contentInset.top = 150
            return emptyImageView
        default:
            return activityIndicator
        }
    }
    
    // MARK: - COREDATA
    private func getStoredData() {
        savedComics = CoreDataManager.shared.getSavedComics()
    }
    
    // MARK: - DATA
    private func fetchData() {
        for comic in savedComics {
            var urlString = "https://gateway.marvel.com:443/v1/public/comics/\(comic.id)"
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
        
        if let APIData = try? decoder.decode(Comics.self, from: json) {
            if let APIComic = APIData.data.results.first {
                
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    
                    self.comics.append(APIComic)
                    self.tableView.insertRows(at: [IndexPath(row: self.comics.count - 1, section: 0)], with: .automatic)
                    
                    if APIComic.id == self.savedComics.last?.id ?? 0 {
                        self.tableView.tableFooterView = createTableViewFooter(state: .done)
                    }
                }
            }
        }
    }
}


// MARK: - SAVE BUTTON EXT
extension SavedComicsVC: SaveButtonDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
        
        if let itemID = itemID {
            delegate?.connect(id: itemID)
        }
        
        if let row = row {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ComicCell else { return }
            cell.didTapSave()
        }
    }
}

// MARK: - TABLEVIEW EXT
extension SavedComicsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComicCell.id, for: indexPath) as? ComicCell else { fatalError() }
        cell.set(comic: comics[indexPath.row], isSaved: savedComics.contains(where: { $0.id == comics[indexPath.row].id }))
        cell.delegate = self
        
        /// Getting the thumbnail image
        cell.thumbNailImageView.image = .none
        cell.activityIndicator.startAnimating()
        
        if thumbnails[comics[indexPath.row].id] != nil {
            cell.activityIndicator.stopAnimating()
            cell.thumbNailImageView.image = UIImage(data: thumbnails[comics[indexPath.row].id]!)
        } else {
            ModelImageManager.shared.getImageData(for: comics[indexPath.row].thumbnail) {
                [weak self] data in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.thumbNailImageView.image = UIImage(data: data)
                    
                    if strongSelf.comics.count > indexPath.row {
                        self?.thumbnails[strongSelf.comics[indexPath.row].id] = data
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = ComicDetailsVC()
        dest.set(comic: comics[indexPath.row], rowID: indexPath.row, isSaved: savedComics.contains(where: { $0.id == comics[indexPath.row].id }))
        dest.delegate = self
        
        navigationController?.pushViewController(dest, animated: true)
    }
}
