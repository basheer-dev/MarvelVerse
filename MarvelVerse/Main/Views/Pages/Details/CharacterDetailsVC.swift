//
//  CharacterDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 07/07/2023.
//

import UIKit


final class CharacterDetailsVC: UIViewController {
    private var characterID = Int()
    private var isSaved: Bool = false
    
    var delegate: SaveButtonDelegate?
    
    private var scrollView: UIView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.showsVerticalScrollIndicator = false
                
        return scroll
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .bold)
        
        return label
    }()
    
    lazy var descriptionTitleLabel: UILabel = getTitleLabel(title: "About")
    lazy var modificationTitleLabel: UILabel = getTitleLabel(title: "Modified")
    lazy var comicsCountTitleLabel: UILabel = getTitleLabel(title: "Comics")
    lazy var seriesCountTitleLabel: UILabel = getTitleLabel(title: "Series")
    
    lazy var descriptionLabel: UILabel = getSubTitleLabel()
    lazy var modificationLabel: UILabel = getSubTitleLabel()
    lazy var comicsCountLabel: UILabel = getSubTitleLabel()
    lazy var seriesCountLabel: UILabel = getSubTitleLabel()
    
    lazy var firstSeparator: UIView = getSeparator()
    lazy var secondSeparator: UIView = getSeparator()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 125
        imageView.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
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
    
    private func getSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 1
        
        return view
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.hidesWhenStopped = true
        view.startAnimating()
        view.color = .systemRed
        
        return view
    }()
    
    private let detailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.cornerStyle = .medium
        button.configuration?.title = "Details"
        button.configuration?.baseForegroundColor = .systemCyan
        
        return button
    }()
    
    private let comicsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .gray()
        button.configuration?.cornerStyle = .medium
        button.configuration?.title = "Comics"
        button.configuration?.baseForegroundColor = .systemOrange
        
        return button
    }()
    
    private var detailsURLString: String = ""
    private var comicsURLString: String = ""
    
    private lazy var saveButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapSave))
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.addSubview(thumbnailImageView)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(idLabel)
        scrollView.addSubview(comicsCountTitleLabel)
        scrollView.addSubview(comicsCountLabel)
        scrollView.addSubview(firstSeparator)
        scrollView.addSubview(seriesCountTitleLabel)
        scrollView.addSubview(seriesCountLabel)
        scrollView.addSubview(secondSeparator)
        scrollView.addSubview(modificationTitleLabel)
        scrollView.addSubview(modificationLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(detailsButton)
        scrollView.addSubview(comicsButton)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(character: Character, isSaved: Bool = false) {
        characterID = character.id
        
        nameLabel.text = character.name
        idLabel.text = "CharacterID | \(character.id)"
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: character.description)
        modificationLabel.text = ModelDateManager.shared.getDate(from: character.modified)
        
        if isSaved == true {
            self.isSaved = true
            saveButton.image = UIImage(systemName: "bookmark.fill")
        }
        
        /// Counts
        comicsCountLabel.text = "0"
        if let characterComics = character.comics {
            if let comicsCount = characterComics.available {
                comicsCountLabel.text = String(comicsCount)
            }
        }
        
        seriesCountLabel.text = "0"
        if let characterSeries = character.series {
            if let seriesCount = characterSeries.available {
                seriesCountLabel.text = String(seriesCount)
            }
        }
        
        ModelImageManager.shared.getImageData(for: character.thumbnail) {
            [weak self] data in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.thumbnailImageView.image = UIImage(data: data)
            }
        }
        
        /// Getting the urls
        detailsURLString = URLManager.shared.getURL(from: character.urls, isDetailsURL: true)
        comicsURLString = URLManager.shared.getURL(from: character.urls, isComicsURL: true)
        
        if detailsURLString.isEmpty {
            detailsButton.configuration?.baseForegroundColor = .systemGray
            detailsButton.isUserInteractionEnabled = false
        }
        
        if comicsURLString.isEmpty {
            comicsButton.configuration?.baseForegroundColor = .systemGray
            comicsButton.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - ACTIONS
    @objc private func didTapSave() {
        isSaved.toggle()
        
        if isSaved == true {
            CoreDataManager.shared.saveObject(type: .Character, id: characterID)
            saveButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            CoreDataManager.shared.deleteObject(type: .Character, id: characterID)
            saveButton.image = UIImage(systemName: "bookmark")
        }
        
        delegate?.didTapSaveButton(row: nil, itemID: nil)
    }
    
    // MARK: - LAYOUTS CONFIG
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            thumbnailImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 250),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 250),
            
            activityIndicator.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            idLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            
            comicsCountTitleLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 75),
            comicsCountTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            comicsCountLabel.topAnchor.constraint(equalTo: comicsCountTitleLabel.bottomAnchor, constant: 5),
            comicsCountLabel.leadingAnchor.constraint(equalTo: comicsCountTitleLabel.leadingAnchor),
            
            firstSeparator.topAnchor.constraint(equalTo: comicsCountTitleLabel.topAnchor),
            firstSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4 + 25),
            firstSeparator.widthAnchor.constraint(equalToConstant: 2),
            firstSeparator.bottomAnchor.constraint(equalTo: comicsCountLabel.bottomAnchor),
            
            modificationTitleLabel.topAnchor.constraint(equalTo: comicsCountTitleLabel.topAnchor),
            modificationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            modificationLabel.topAnchor.constraint(equalTo: comicsCountLabel.topAnchor),
            modificationLabel.centerXAnchor.constraint(equalTo: modificationTitleLabel.centerXAnchor),
            
            secondSeparator.topAnchor.constraint(equalTo: comicsCountTitleLabel.topAnchor),
            secondSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4 - 25),
            secondSeparator.widthAnchor.constraint(equalToConstant: 2),
            secondSeparator.bottomAnchor.constraint(equalTo: comicsCountLabel.bottomAnchor),
            
            seriesCountTitleLabel.topAnchor.constraint(equalTo: comicsCountTitleLabel.topAnchor),
            seriesCountTitleLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            seriesCountLabel.topAnchor.constraint(equalTo: comicsCountLabel.topAnchor),
            seriesCountLabel.trailingAnchor.constraint(equalTo: seriesCountTitleLabel.trailingAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: comicsCountLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            detailsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            detailsButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 15),
            detailsButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            detailsButton.heightAnchor.constraint(equalToConstant: 44),
            
            comicsButton.topAnchor.constraint(equalTo: detailsButton.topAnchor),
            comicsButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -15),
            comicsButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            comicsButton.heightAnchor.constraint(equalToConstant: 44),
            comicsButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -25)
        ])
    }
}
