//
//  SeriesDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 05/07/2023.
//

import UIKit

final class SeriesDetailsVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .systemRed
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    private let typeLabel: UILabel = {
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
    
    private let seriesImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 5
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var startYearTitleLabel: UILabel = getTitleLabel(title: "Started")
    private lazy var endYearTitleLabel: UILabel = getTitleLabel(title: "Ended")
    private lazy var modificationTitleLabel: UILabel = getTitleLabel(title: "Modified")
    
    private lazy var startYearLabel: UILabel = getSubTitleLabel()
    private lazy var endYearLabel: UILabel = getSubTitleLabel()
    private lazy var modificationDateLabel: UILabel = getSubTitleLabel()
    
    private lazy var firstSeparator: UIView = getSeparator()
    private lazy var secondSeparator: UIView = getSeparator()
    
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
    
    private func getSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 1
        
        return view
    }
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(typeLabel)
        scrollView.addSubview(saveButton)
        scrollView.addSubview(seriesImageView)
        scrollView.addSubview(ratingLabel)
        scrollView.addSubview(startYearTitleLabel)
        scrollView.addSubview(startYearLabel)
        scrollView.addSubview(endYearTitleLabel)
        scrollView.addSubview(endYearLabel)
        scrollView.addSubview(modificationTitleLabel)
        scrollView.addSubview(modificationDateLabel)
        scrollView.addSubview(firstSeparator)
        scrollView.addSubview(secondSeparator)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(series: Series) {
        titleLabel.text = ModelTextManager.shared.getTitle(from: series.title)
        typeLabel.text = "Type | \(ModelTextManager.shared.getStringInfo(from: series.type))"
        ratingLabel.text = "Rating | \(ModelTextManager.shared.getStringInfo(from: series.rating))"
        startYearLabel.text = ModelDateManager.shared.getYear(from: series.startYear)
        endYearLabel.text = ModelDateManager.shared.getYear(from: series.endYear)
        modificationDateLabel.text = ModelDateManager.shared.getDate(from: series.modified)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: series.description)
        
        ///Getting the series image
        ModelImageManager.shared.getImageData(for: series.thumbnail) {
            [weak self] data in
            DispatchQueue.main.async {
                self?.seriesImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - LAYOUTS CONFIG
    private func configureLayouts() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            typeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            seriesImageView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 50),
            seriesImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seriesImageView.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            seriesImageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: seriesImageView.bottomAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            startYearTitleLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 50),
            startYearTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            startYearLabel.topAnchor.constraint(equalTo: startYearTitleLabel.bottomAnchor, constant: 5),
            startYearLabel.leadingAnchor.constraint(equalTo: startYearTitleLabel.leadingAnchor),
            
            modificationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modificationTitleLabel.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            
            modificationDateLabel.topAnchor.constraint(equalTo: startYearLabel.topAnchor),
            modificationDateLabel.centerXAnchor.constraint(equalTo: modificationTitleLabel.centerXAnchor),
            
            endYearTitleLabel.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            endYearTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            
            endYearLabel.topAnchor.constraint(equalTo: startYearLabel.topAnchor),
            endYearLabel.trailingAnchor.constraint(equalTo: endYearTitleLabel.trailingAnchor),
            
            firstSeparator.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            firstSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4 + 25),
            firstSeparator.bottomAnchor.constraint(equalTo: startYearLabel.bottomAnchor),
            firstSeparator.widthAnchor.constraint(equalToConstant: 2),
            
            secondSeparator.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            secondSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4 - 25),
            secondSeparator.bottomAnchor.constraint(equalTo: startYearLabel.bottomAnchor),
            secondSeparator.widthAnchor.constraint(equalToConstant: 2),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: startYearLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        ])
    }
}
