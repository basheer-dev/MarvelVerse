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
        let urlString = "https://gateway.marvel.com:443/v1/public/comics?limit=20&format=comic&formatType=comic&hasDigitalIssue=false&orderBy=title&ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"
        
        fetchData(from: urlString)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    // MARK: - DATA
    private func fetchData(from urlString: String, offset: Int = 3) {
        let urlString = urlString + "&offset=\(offset)"
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // parse JSON
                    self?.parseJSON(json: data)
                }
            }
        }
    }
    
    private func parseJSON(json: Data) {
        let jsonDecoder = JSONDecoder()
        if let jsonComics = try? jsonDecoder.decode(Comics.self, from: json) {
            let parsedComics = jsonComics.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                guard let strongSelf = self else { return }
                for comic in parsedComics {
                    self?.comics.append(comic)
                    self?.tableView.insertRows(at: [IndexPath(row: strongSelf.comics.count - 1, section: 0)], with: .automatic)
                }
            }
        } else {
            print("couldn't parse json")
        }
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
            URLManager.shared.getAPIImageData(image: comics[indexPath.row].thumbnail) {
                [weak self] data in
                DispatchQueue.main.async {
                    cell.thumbNailImageView.image = UIImage(data: data)
                    
                    if let comicId = self?.comics[indexPath.row].id {
                        self?.thumbnails[comicId] = data
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
            let urlString = "https://gateway.marvel.com:443/v1/public/comics?limit=20&format=comic&formatType=comic&hasDigitalIssue=false&orderBy=title&ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"
            
            fetchData(from: urlString, offset: comics.count)
            
//            DispatchQueue.global(qos: .userInteractive).async {
//                [weak self] in
//                if let url = URL(string: urlString) {
//                    if let data = try? Data(contentsOf: url) {
//                        self?.parseJSON(json: data)
//                    }
//                }
//            }
        }
    }
}
