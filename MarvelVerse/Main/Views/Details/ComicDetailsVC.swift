//
//  ComicDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import UIKit

class ComicDetailsVC: UIViewController {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        return scroll
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize.height = 400
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ComicImageCell.self, forCellWithReuseIdentifier: ComicImageCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapSave))
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        scrollView.addSubview(collectionView)
        
        configureLayouts()
    }
    
    // MARK: - ACTIONS
    @objc private func didTapSave() {
        
    }
    
    // MARK: LAYOUT CONFIG
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}


// MARK: - COLLECTIONVIEW EXT
extension ComicDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicImageCell.id, for: indexPath) as? ComicImageCell else { fatalError() }
                
        return cell
    }
}
