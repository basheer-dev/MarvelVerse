//
//  SeriesVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit

final class SeriesVC: UIViewController {
    
    private var allSeries: [Series] = []
    
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
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    // MARK: - DATA
    private func fetchData() {
        let urlString = "https://gateway.marvel.com:443/v1/public/series?ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"
        
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
        
        if let jsonSeries = try? jsonDecoder.decode(AllSeries.self, from: json) {
            allSeries = jsonSeries.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        } else {
            print("Couldn't parse series from JSON")
        }
    }
}


// MARK: - TABLEVIEW EXT
extension SeriesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesCell.id, for: indexPath) as? SeriesCell else { fatalError() }
        cell.set(series: allSeries[indexPath.row])
        
        return cell
    }
}
