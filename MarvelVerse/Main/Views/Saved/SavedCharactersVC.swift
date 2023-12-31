//
//  SavedCharactersVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 10/07/2023.
//

import UIKit

final class SavedCharactersVC: UIViewController {
    private var characters: [Character] = []
    private var savedCharacters: [SavedCharacter] = []
    private var thumbnails: [Int: Data] = [:]
        
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
    
    private lazy var emptyImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        view.image = UIImage(systemName: "bookmark.slash")
        view.tintColor = .systemRed
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    // MARK: - VLD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Saved Characters"
        
        getStoredData()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 30),
            emptyImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - COREDATA
    private func getStoredData() {
        savedCharacters = CoreDataManager.shared.getSavedCharacters()
        
        if savedCharacters.isEmpty {
            activityIndicator.stopAnimating()
            emptyImageView.isHidden = false
        }
    }
    
    // MARK: - DATA
    private func fetchData() {
        
        for character in savedCharacters {
            var urlString = "https://gateway.marvel.com:443/v1/public/characters/\(character.id)"
            urlString += URLManager.shared.getAPIUserKeyInfo()
            
            DispatchQueue.global(qos: .userInteractive).async {
                [weak self] in
                
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        self?.parseJSON(json: data)
                    }
                }
            }
        }
    }
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Characters.self, from: json) {
            if let APICharacter = APIData.data.results.first {
                
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    
                    self.activityIndicator.stopAnimating()
                    self.characters.append(APICharacter)
                    self.collectionView.insertItems(at: [IndexPath(item: self.characters.count - 1, section: 0)])
                }
            }
        }
    }
}


// MARK: - SAVE BUTTON EXT
extension SavedCharactersVC: SaveButtonDelegate {
    
    func didTapSaveButton(row: Int?, itemID: Int?) {
        getStoredData()
    }
}


// MARK: - COLLECTION VIEW EXT
extension SavedCharactersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
}
