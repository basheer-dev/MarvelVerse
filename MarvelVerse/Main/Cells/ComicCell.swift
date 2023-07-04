//
//  ComicCell.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 02/07/2023.
//

import UIKit

final class ComicCell: UITableViewCell {
    static let id: String = "ComicContainer"
    
    private let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.isUserInteractionEnabled = true
        
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
        label.numberOfLines = 0
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
    
    func set(comic: Comic) {
        titleLabel.text = comic.title
        pagesCountLabel.text = "Pages: \(comic.pageCount ?? 0)"
        thumbNailImageView.image = .none
        
        /// Handling the description
        descriptionLabel.text = "No available description"
        
        if let descriptionText = comic.description {
            if !descriptionText.isEmpty {
                descriptionLabel.text = descriptionText.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&ndash;", with: "&").replacingOccurrences(of: "32 PGS./MARVEL PSR...$3.50", with: "").trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
            }
        }
        
        /// Getting the thumbnail image
        URLManager.shared.getComicImageData(comicImage: comic.thumbnail) {
            [weak self] data in
            DispatchQueue.main.async {
                self?.thumbNailImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - ACTIONS
    @objc private func saveButtonTapped() {
        print("save")
    }
    
    @objc private func didTapComic() {
        print(titleLabel.text ?? "")
    }
    
    // MARK: - SUBVIEWS
    private func configureSubviews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapComic))
        thumbNailImageView.isUserInteractionEnabled = true
        thumbNailImageView.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        addSubview(thumbNailImageView)
        addSubview(saveButton)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(pagesCountLabel)
        
        NSLayoutConstraint.activate([
            thumbNailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbNailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbNailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbNailImageView.heightAnchor.constraint(equalToConstant: 500),
            
            saveButton.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            pagesCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            pagesCountLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            pagesCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}
