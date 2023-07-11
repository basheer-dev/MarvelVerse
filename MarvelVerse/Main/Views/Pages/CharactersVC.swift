//
//  CharactersVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit

final class CharactersVC: UIViewController {
    private var characters: [Character] = []
    private var savedCharacters: [SavedCharacter] = []
    private var thumbnails: [Int: Data] = [:]
    private var searchTitle: String = ""
    private var globalOffset: Int = 0
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.frame.width/2 - 20, height: 200)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemRed
        
        return activityIndicator
    }()

    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        fetchData(title: searchTitle)
        getStoredData()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - COREDATA
    private func getStoredData() {
        savedCharacters = CoreDataManager.shared.getSavedCharacters()
    }
    
    // MARK: - DATA
    private func fetchData(title: String = "", offset: Int = 0) {
        var urlString = "https://gateway.marvel.com:443/v1/public/characters"
        urlString += URLManager.shared.getAPIUserKeyInfo() + "&orderBy=name"
        
        if offset > 0 {
            urlString += "&offset=\(offset)&limit=20"
        }
        
        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
            
            if title.lowercased() == "spider man" {
                urlString += "&nameStartsWith=\(title.replacingOccurrences(of: " ", with: "-"))"
            } else {
                urlString += "&nameStartsWith=\(title.replacingOccurrences(of: " ", with: "%20"))"
            }
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parseJSON(json: data)
                }
            }
        }
    }
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Characters.self, from: json) {
            let APICharacters = APIData.data.results
            
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
                
                self.activityIndicator.stopAnimating()
                
                for character in APICharacters {
                    if self.characters.contains(where: { $0.id == character.id }) == false && character.thumbnail?.path?.contains("/image_not_available") == false {
                        self.characters.append(character)
                        self.collectionView.insertItems(at: [IndexPath(item: self.characters.count - 1, section: 0)])
                    } else {
                        self.globalOffset += 1
                    }
                }
            }
        }
    }
}

// MARK: - SAVE BUTTON EXT
extension CharactersVC: SaveButtonDelegate {
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
    }
}


// MARK: - SEARCHAPI EXT
extension CharactersVC: APIDataSearch {
    func didSearchFor(title: String) {
        clearData()
        searchTitle = title
        fetchData(title: searchTitle)
    }
    
    private func clearData() {
        thumbnails.removeAll()
        characters.removeAll()
        collectionView.reloadData()
    }
}


// MARK: - COLLECTION VIEW EXT
extension CharactersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.id, for: indexPath) as? CharacterCell else { fatalError() }
        cell.set(character: characters[indexPath.item])
        
        cell.backgroundColor = .secondarySystemBackground
        cell.layer.cornerRadius = 15
        
        /// Getting the thumbnail image
        cell.activityIndicator.startAnimating()
        cell.characterImageView.image = .none
        
        if thumbnails[characters[indexPath.item].id] != nil {
            cell.activityIndicator.stopAnimating()
            cell.characterImageView.image = UIImage(data: thumbnails[characters[indexPath.item].id]!)
        } else {
            ModelImageManager.shared.getImageData(for: characters[indexPath.item].thumbnail) {
                [weak self] data in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.characterImageView.image = UIImage(data: data)
                    
                    if self.characters.count > indexPath.item {
                        self.thumbnails[self.characters[indexPath.item].id] = data
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dest = CharacterDetailsVC()
        dest.set(character: characters[indexPath.row], isSaved: savedCharacters.contains(where: { $0.id == characters[indexPath.item].id }))
        dest.delegate = self
        
        navigationController?.pushViewController(dest, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == characters.count - 1 {
            fetchData(title: searchTitle, offset: characters.count + globalOffset)
        }
    }
}
