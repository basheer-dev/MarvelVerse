//
//  ComicCell.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit


protocol SaveButtonDelegate {
    func didTapSaveButton(row: Int?, itemID: Int?)
}


final class ComicCell: UITableViewCell {
    static let id: String = "ComicContainer"
    
    private var comicID = Int()
    var isSaved: Bool = false
    
    var delegate: SaveButtonDelegate?
    
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.layer.borderColor = UIColor(cgColor: CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)).cgColor
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "bookmark")
        button.configuration?.baseForegroundColor = .systemRed
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .justified
        
        return label
    }()
    
    private let pagesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.hidesWhenStopped = true
        view.color = .systemRed
        view.startAnimating()
        
        return view
    }()
        
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(comic: Comic, isSaved: Bool = false) {
        comicID = comic.id
        
        titleLabel.text = ModelTextManager.shared.getTitle(from: comic.title)
        pagesCountLabel.text = "Pages | \(comic.pageCount ?? 0)"
        thumbNailImageView.image = .none
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: comic.description)
        
        if isSaved == true {
            self.isSaved = true
            saveButton.configuration?.image = UIImage(systemName: "bookmark.fill")
        }
    }
    
    // MARK: - ACTIONS
    @objc func didTapSave() {
        isSaved.toggle()
        
        if isSaved == true {
            CoreDataManager.shared.saveObject(type: .Comic, id: comicID)
            saveButton.configuration?.image = UIImage(systemName: "bookmark.fill")
        } else {
            CoreDataManager.shared.deleteObject(type: .Comic, id: comicID)
            saveButton.configuration?.image = UIImage(systemName: "bookmark")
        }
        
        delegate?.didTapSaveButton(row: nil, itemID: comicID)
    }
    
    // MARK: - SUBVIEWS
    private func configureSubviews() {
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        addSubview(thumbNailImageView)
        addSubview(activityIndicator)
        addSubview(saveButton)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(pagesCountLabel)
        
        NSLayoutConstraint.activate([
            thumbNailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbNailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            thumbNailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            thumbNailImageView.heightAnchor.constraint(equalToConstant: 500),
            
            activityIndicator.centerXAnchor.constraint(equalTo: thumbNailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: thumbNailImageView.centerYAnchor),
            
            saveButton.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pagesCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            pagesCountLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            pagesCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}
