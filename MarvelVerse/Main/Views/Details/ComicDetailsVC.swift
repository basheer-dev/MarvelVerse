//
//  ComicDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import UIKit

class ComicDetailsVC: UIViewController {
    var comicImages: [ComicImage] = []
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.showsVerticalScrollIndicator = false
        
        return scroll
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemRed
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    let formatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .bold)
        
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "bookmark")
        button.configuration?.baseForegroundColor = .systemRed
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ComicImageCell.self, forCellWithReuseIdentifier: ComicImageCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return collectionView
    }()
    
    let pagesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemRed
        label.textAlignment = .right
        
        return label
    }()
    
    let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Published"
        
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About"
        
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .tinted()
        button.configuration?.title = "Marvel"
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.baseForegroundColor = .systemRed
        
        return button
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(formatLabel)
        scrollView.addSubview(saveButton)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(pagesCountLabel)
        scrollView.addSubview(dateTitleLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(testButton)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(comic: Comic) {
        titleLabel.text = comic.title
        formatLabel.text = "Format | \(comic.format ?? "Not specified")"
        pagesCountLabel.text = "Pages: \(comic.pageCount ?? 0)"
        dateLabel.text = URLManager.shared.getPubDate(from: comic.dates)
        descriptionLabel.text = URLManager.shared.getDescription(description: comic.description)
        
        /// Getting the comic's thumbnail and related images
        if let thumbnail = comic.thumbnail {
            comicImages.append(thumbnail)
        }
        if let comicImages = comic.images {
            self.comicImages += comicImages
        }
        collectionView.reloadData()
    }
    
    // MARK: - ACTIONS
    @objc private func didTapSave() {
        
    }
    
    // MARK: LAYOUT CONFIG
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            formatLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            formatLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            collectionView.topAnchor.constraint(equalTo: formatLabel.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            
            pagesCountLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            pagesCountLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            dateTitleLabel.topAnchor.constraint(equalTo: pagesCountLabel.bottomAnchor, constant: 50),
            dateTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            testButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 1000),
            testButton.widthAnchor.constraint(equalToConstant: 150),
            testButton.heightAnchor.constraint(equalToConstant: 44),
            testButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            testButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
    }
}


// MARK: - COLLECTIONVIEW EXT
extension ComicDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicImageCell.id, for: indexPath) as? ComicImageCell else { fatalError() }
        cell.set(image: comicImages[indexPath.row])
        cell.contentMode = .scaleAspectFill
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270, height: 400)
    }
}
