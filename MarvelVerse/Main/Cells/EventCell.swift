//
//  EventCell.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 08/07/2023.
//

import UIKit

final class EventCell: UITableViewCell {
    static let id: String = "EventContainer"
    
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
    
    private let startYearLabel: UILabel = {
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
    
    func set(event: Event) {
        titleLabel.text = ModelTextManager.shared.getTitle(from: event.title)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: event.description)
        startYearLabel.text = ModelDateManager.shared.getDate(from: event.start, getYearOnly: true)
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
        addSubview(startYearLabel)
        
        NSLayoutConstraint.activate([
            thumbNailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbNailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            thumbNailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            thumbNailImageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            saveButton.topAnchor.constraint(equalTo: thumbNailImageView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            startYearLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            startYearLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            startYearLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}
