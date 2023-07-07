//
//  SeriesCell.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 05/07/2023.
//

import UIKit

final class SeriesCell: UITableViewCell {
    static let id = "SeriesContainer"
    
    let seriesImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        
        configureSubviews()
    }
    
    func set(series: Series) {
        titleLabel.text = ModelTextManager.shared.getTitle(from: series.title)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: series.description)
        ratingLabel.text = "Rating | \(ModelTextManager.shared.getStringInfo(from: series.rating))"
        
        /// Getting the series image
        ModelImageManager.shared.getImageData(for: series.thumbnail) {
            [weak self] data in
            DispatchQueue.main.async {
                self?.seriesImageView.image = UIImage(data: data)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  SUBVIEWS
    private func configureSubviews() {
        addSubview(seriesImageView)
        addSubview(saveButton)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            seriesImageView.topAnchor.constraint(equalTo: topAnchor),
            seriesImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            seriesImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            seriesImageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            saveButton.topAnchor.constraint(equalTo: seriesImageView.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
}
