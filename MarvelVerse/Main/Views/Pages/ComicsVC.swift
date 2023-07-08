//
//  ComicsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 01/07/2023.
//

import UIKit


final class ComicsVC: UIViewController {
    
    private var comics: [Comic] = []
    private var thumbnails: [Int: Data] = [:]
    private var searchTitle: String = ""
    private var globalOffset: Int = 0
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ComicCell.self, forCellReuseIdentifier: ComicCell.id)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        fetchData(title: searchTitle)
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
        
        return activityIndicator
    }
    
    // MARK: - DATA
    private func fetchData(title: String = "", offset: Int = 0) {
        var urlString = "https://gateway.marvel.com:443/v1/public/comics"
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
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Comics.self, from: json) {
            let APIComics = APIData.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
                
                for comic in APIComics {
                    if self.comics.contains(where: { $0.id == comic.id }) == false && comic.thumbnail?.path?.contains("/image_not_available") == false {
                        self.comics.append(comic)
                        self.tableView.insertRows(at: [IndexPath(row: self.comics.count - 1, section: 0)], with: .automatic)
                    } else {
                        globalOffset += 1
                    }
                }
            }
        }
    }
}


// MARK: - APISEARCH EXT
extension ComicsVC: APIDataSearch {
    
    func didSearchFor(title: String) {
        clearData()
        searchTitle = title
        fetchData(title: searchTitle)
    }
    
    private func clearData() {
        thumbnails.removeAll()
        comics.removeAll()
        tableView.reloadData()
    }
}


// MARK: - TABLEVIEW EXT
extension ComicsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComicCell.id, for: indexPath) as? ComicCell else { fatalError() }
        cell.set(comic: comics[indexPath.row])
        
        /// Getting the thumbnail image
        cell.thumbNailImageView.image = .none
        
        if thumbnails[comics[indexPath.row].id] != nil {
            cell.thumbNailImageView.image = UIImage(data: thumbnails[comics[indexPath.row].id]!)
        } else {
            ModelImageManager.shared.getImageData(for: comics[indexPath.row].thumbnail) {
                [weak self] data in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
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
        dest.set(comic: comics[indexPath.row])
        
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == comics.count - 1 {
            /// The user has reached the bottom
            /// Get more data

            fetchData(title: searchTitle, offset: comics.count + globalOffset)
        }
    }
}
