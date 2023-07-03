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
        
//        imageView.contentMode = .center
//        imageView.tintColor = .systemRed
//        imageView.backgroundColor = .systemGray6
        
        return imageView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "star")
        button.configuration?.baseForegroundColor = .systemRed
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a Marvel comic"
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a description and I have no idea what the hell I'm writing. I guess my name is Basheer and I hate going to college."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private let pagesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pages: 112"
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemRed
        
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
    
    // MARK: - ACTIONS
    @objc private func saveButtonTapped() {
        print("save")
    }
    
    // MARK: - SUBVIEWS
    private func configureSubviews() {
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
            thumbNailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 800),
//            thumbNailImageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            saveButton.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
//            titleLabel.topAnchor.constraint(equalTo: saveButton.topAnchor),
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
