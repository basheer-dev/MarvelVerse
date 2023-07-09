//
//  ComicDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import UIKit

protocol SaveButtonDelegate {
    func didTapSaveButton(row: Int)
}

final class ComicDetailsVC: UIViewController {
    private var comicImages: [APIImage] = []
    private var comicID = Int()
    private var isSaved: Bool = false
    private var rowID: Int = 0
    
    var delegate: SaveButtonDelegate?
    
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
    
    private lazy var pricesTitleLabel: UILabel = getTitleLabel(title: "Prices")
    private lazy var printPriceTitleLabel: UILabel = getSubTitleLabel(title: "Print Price")
    private lazy var digitalCopyPriceTitleLabel: UILabel = getSubTitleLabel(title: "Digital Copy")
    private lazy var printPriceLabel: UILabel = getPriceLabel()
    private lazy var digitalCopyPriceLabel: UILabel = getPriceLabel()
    
    private func getTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = title
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }
    
    private func getSubTitleLabel(title: String = "") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        if !title.isEmpty {
            label.text = title
        }
        
        return label
    }
    
    private func getPriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 1
        label.textColor = .systemGreen
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .bold)
        
        return label
    }
    
    private let detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.cornerStyle = .medium
        button.configuration?.title = "Details"
        button.configuration?.baseForegroundColor = .systemCyan
        
        return button
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.cornerStyle = .medium
        button.configuration?.title = "Purchase"
        button.configuration?.baseForegroundColor = .systemGreen
        
        return button
    }()
    
    private var detailsURLString: String = ""
    private var purchaseURLString: String = ""
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
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
        scrollView.addSubview(pricesTitleLabel)
        scrollView.addSubview(printPriceTitleLabel)
        scrollView.addSubview(printPriceLabel)
        scrollView.addSubview(digitalCopyPriceTitleLabel)
        scrollView.addSubview(digitalCopyPriceLabel)
        scrollView.addSubview(detailsButton)
        scrollView.addSubview(purchaseButton)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(comic: Comic, rowID: Int, isSaved: Bool = false) {
        comicID = comic.id
        self.rowID = rowID
        
        titleLabel.text = ModelTextManager.shared.getTitle(from: comic.title)
        formatLabel.text = "Format | \(comic.format ?? "Not specified")"
        pagesCountLabel.text = "Pages | \(comic.pageCount ?? 0)"
        dateLabel.text = ModelDateManager.shared.getPubDate(from: comic.dates)
        modificationDate.text = ModelDateManager.shared.getDate(from: comic.modified)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: comic.description)
        printPriceLabel.text = ModelTextManager.shared.getPrice(from: comic.prices, isPrintPrice: true)
        digitalCopyPriceLabel.text = ModelTextManager.shared.getPrice(from: comic.prices, isDigitalCopyPrice: true)
        
        if isSaved == true {
            self.isSaved = true
            saveButton.configuration?.image = UIImage(systemName: "bookmark.fill")
        }
        
        
        if printPriceLabel.text == "N/A" {
            printPriceLabel.textColor = .systemRed
        }
        
        if digitalCopyPriceLabel.text == "N/A" {
            digitalCopyPriceLabel.textColor = .systemRed
        }
        
        /// Getting the comic's thumbnail and related images
        if let thumbnail = comic.thumbnail {
            comicImages.append(thumbnail)
        }
        if let comicImages = comic.images {
            self.comicImages += comicImages
        }
        collectionView.reloadData()
        
        /// Getting the urls
        detailsURLString = URLManager.shared.getURL(from: comic.urls, isDetailsURL: true)
        purchaseURLString = URLManager.shared.getURL(from: comic.urls, isPurchaseURL: true)
        
        if detailsURLString.isEmpty {
            detailsButton.configuration?.baseForegroundColor = .systemGray
            detailsButton.isUserInteractionEnabled = false
        }
        
        if purchaseURLString.isEmpty {
            purchaseButton.configuration?.baseForegroundColor = .systemGray
            purchaseButton.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - ACTIONS
    @objc private func didTapSave() {
        isSaved.toggle()
        
        if isSaved == true {
            CoreDataManager.shared.saveObject(type: .Comic, id: comicID)
            saveButton.configuration?.image = UIImage(systemName: "bookmark.fill")
        } else {
            CoreDataManager.shared.deleteObject(type: .Comic, id: comicID)
            saveButton.configuration?.image = UIImage(systemName: "bookmark")
        }
        
        delegate?.didTapSaveButton(row: rowID)
    }
    
    // MARK: - LAYOUT CONFIG
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
            
            pricesTitleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50),
            pricesTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            printPriceTitleLabel.topAnchor.constraint(equalTo: pricesTitleLabel.bottomAnchor, constant: 5),
            printPriceTitleLabel.leadingAnchor.constraint(equalTo: pricesTitleLabel.leadingAnchor),
            printPriceLabel.topAnchor.constraint(equalTo: printPriceTitleLabel.topAnchor),
            printPriceLabel.leadingAnchor.constraint(equalTo: digitalCopyPriceLabel.leadingAnchor),
            
            digitalCopyPriceTitleLabel.topAnchor.constraint(equalTo: printPriceTitleLabel.bottomAnchor, constant: 5),
            digitalCopyPriceTitleLabel.leadingAnchor.constraint(equalTo: pricesTitleLabel.leadingAnchor),
            digitalCopyPriceLabel.topAnchor.constraint(equalTo: digitalCopyPriceTitleLabel.topAnchor),
            digitalCopyPriceLabel.leadingAnchor.constraint(equalTo: digitalCopyPriceTitleLabel.trailingAnchor, constant: 10),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: digitalCopyPriceTitleLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            detailsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            detailsButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 15),
            detailsButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            detailsButton.heightAnchor.constraint(equalToConstant: 44),
            
            purchaseButton.topAnchor.constraint(equalTo: detailsButton.topAnchor),
            purchaseButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: -15),
            purchaseButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            purchaseButton.heightAnchor.constraint(equalToConstant: 44),
            purchaseButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25)
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
