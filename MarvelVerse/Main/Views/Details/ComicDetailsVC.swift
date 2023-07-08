//
//  ComicDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import UIKit

final class ComicDetailsVC: UIViewController {
    private var comicImages: [APIImage] = []
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.showsVerticalScrollIndicator = false
        
        return scroll
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemRed
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let formatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .bold)
        
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "bookmark")
        button.configuration?.baseForegroundColor = .systemRed
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
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
    
    private let pagesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var dateTitleLabel: UILabel = getTitleLabel(title: "Published")
    private lazy var modificationDateTitle: UILabel = getTitleLabel(title: "Modified")
    
    private lazy var dateLabel: UILabel = getSubTitleLabel()
    private lazy var modificationDate: UILabel = getSubTitleLabel()
    
    private let datesSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = getTitleLabel(title: "About")
    
    private lazy var descriptionLabel: UILabel = getSubTitleLabel()
    
    private func getTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }
    
    private func getSubTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }
    
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
        scrollView.addSubview(modificationDateTitle)
        scrollView.addSubview(modificationDate)
        scrollView.addSubview(datesSeparator)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(comic: Comic) {
        titleLabel.text = ModelTextManager.shared.getTitle(from: comic.title)
        formatLabel.text = "Format | \(comic.format ?? "Not specified")"
        pagesCountLabel.text = "Pages | \(comic.pageCount ?? 0)"
        dateLabel.text = ModelDateManager.shared.getPubDate(from: comic.dates)
        modificationDate.text = ModelDateManager.shared.getDate(from: comic.modified)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: comic.description)
        
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
            
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            modificationDateTitle.topAnchor.constraint(equalTo: pagesCountLabel.bottomAnchor, constant: 50),
            modificationDateTitle.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            modificationDate.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 5),
            modificationDate.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            datesSeparator.topAnchor.constraint(equalTo: dateTitleLabel.topAnchor),
            datesSeparator.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            datesSeparator.widthAnchor.constraint(equalToConstant: 2),
            datesSeparator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
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
        
        cell.activityIndicator.startAnimating()
        cell.set(image: comicImages[indexPath.row])
        cell.contentMode = .scaleAspectFill
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270, height: 400)
    }
}
