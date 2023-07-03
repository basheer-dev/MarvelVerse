//
//  ComicsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 01/07/2023.
//

import UIKit

class ComicsVC: UIViewController {
    var comics: [Comic] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ComicCell.self, forCellReuseIdentifier: ComicCell.id)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    // MARK: - FETCHING DATA
    private func fetchData() {
        let urlString = "https://gateway.marvel.com:443/v1/public/comics?limit=20&format=comic&formatType=comic&hasDigitalIssue=false&orderBy=title&ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"
        
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
            comics = jsonComics.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
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
        
        return cell
    }
}
