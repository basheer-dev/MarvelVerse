//
//  EventDetailsVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 08/07/2023.
//

import UIKit

final class EventDetailsVC: UIViewController {
    private var nextEvent: String = ""
    private var nextEventTitle: String = ""
    private var previousEvent: String = ""
    private var previousEventTitle: String = ""
    
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
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
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
    
    private let eventImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 5
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var nextButton: UIButton = getButton()
    private lazy var previousButton: UIButton = getButton()
    
    private lazy var startYearTitleLabel: UILabel = getTitleLabel(title: "Started")
    private lazy var modificationTitleLabel: UILabel = getTitleLabel(title: "Modified")
    private lazy var endYearTitleLabel: UILabel = getTitleLabel(title: "Ended")
    private lazy var descriptionTitleLabel: UILabel = getTitleLabel(title: "About")
    
    private lazy var startYearLabel: UILabel = getSubTitleLabel()
    private lazy var modificationDateLabel: UILabel = getSubTitleLabel()
    private lazy var endYearLabel: UILabel = getSubTitleLabel()
    private lazy var descriptionLabel: UILabel = getSubTitleLabel()
    
    private lazy var firstSeparator: UIView = getSeparator()
    private lazy var secondSeparator: UIView = getSeparator()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.color = .systemRed
        view.hidesWhenStopped = true
        view.startAnimating()
        
        return view
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
    
    private func getButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.setTitleColor(.secondarySystemBackground, for: .highlighted)
        
        return button
    }
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(saveButton)
        scrollView.addSubview(eventImageView)
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(nextButton)
        scrollView.addSubview(previousButton)
        scrollView.addSubview(startYearTitleLabel)
        scrollView.addSubview(startYearLabel)
        scrollView.addSubview(firstSeparator)
        scrollView.addSubview(modificationTitleLabel)
        scrollView.addSubview(modificationDateLabel)
        scrollView.addSubview(secondSeparator)
        scrollView.addSubview(endYearTitleLabel)
        scrollView.addSubview(endYearLabel)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionLabel)
        
        view.addSubview(scrollView)
        
        configureLayouts()
    }
    
    func set(event: Event) {
        titleLabel.text = event.title
        startYearLabel.text = ModelDateManager.shared.getDate(from: event.start, getYearOnly: true)
        modificationDateLabel.text = ModelDateManager.shared.getDate(from: event.modified)
        endYearLabel.text = ModelDateManager.shared.getDate(from: event.end, getYearOnly: true)
        descriptionLabel.text = ModelTextManager.shared.getDescription(from: event.description)
        
        /// Configuring the buttons
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        
        nextButton.isHidden = true
        previousButton.isHidden = true
        
        if let nextEventTitle = event.next?.name, let eventUrl = event.next?.resourceURI {
            nextEvent = eventUrl.replacingOccurrences(of: "http://", with: "https://")
            self.nextEventTitle = nextEventTitle
            
            nextButton.isHidden = false
            nextButton.setTitle("\(nextEventTitle) >", for: .normal)
            nextButton.setTitleColor(.systemRed, for: .normal)
        }
        
        if let previousEventTitle = event.previous?.name, let eventUrl = event.previous?.resourceURI {
            previousEvent = eventUrl.replacingOccurrences(of: "http://", with: "https://")
            self.previousEventTitle = previousEventTitle
            
            previousButton.isHidden = false
            previousButton.setTitle("< \(previousEventTitle)", for: .normal)
            previousButton.setTitleColor(.systemRed, for: .normal)
        }
                
        /// Getting the thumbnail image
        ModelImageManager.shared.getImageData(for: event.thumbnail) {
            [weak self] data in
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.eventImageView.image = UIImage(data: data)
            }
        }
    }
    
    // MARK: - ACTIONS
    @objc private func didTapNext() {
        activityIndicator.startAnimating()
        
        titleLabel.text = nextEventTitle
        eventImageView.image = .none
        nextButton.isHidden = true
        previousButton.isHidden = true
        startYearLabel.text = "Loading ..."
        modificationDateLabel.text = "Loading ..."
        endYearLabel.text = "Loading ..."
        descriptionLabel.text = "Loading ..."
        
        let urlString = nextEvent + URLManager.shared.getAPIUserKeyInfo()
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parseJSON(json: data)
                }
            }
        }
    }
    
    @objc private func didTapPrevious() {
        activityIndicator.startAnimating()
        
        titleLabel.text = previousEventTitle
        eventImageView.image = .none
        nextButton.isHidden = true
        previousButton.isHidden = true
        startYearLabel.text = "Loading ..."
        modificationDateLabel.text = "Loading ..."
        endYearLabel.text = "Loading ..."
        descriptionLabel.text = "Loading ..."
        
        let urlString = previousEvent + URLManager.shared.getAPIUserKeyInfo()
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parseJSON(json: data)
                }
            }
        }
    }
    
    private func parseJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let APIData = try? decoder.decode(Events.self, from: json) {
            if let APIEvent = APIData.data.results.first {
                DispatchQueue.main.async {
                    [weak self] in
                    self?.set(event: APIEvent)
                }
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
            
            saveButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            saveButton.widthAnchor.constraint(equalToConstant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            
            eventImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            eventImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            eventImageView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: eventImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor),
            
            nextButton.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 5),
            nextButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            nextButton.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width/2 - 50),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            
            previousButton.topAnchor.constraint(equalTo: nextButton.topAnchor),
            previousButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previousButton.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width/2 - 30),
            previousButton.heightAnchor.constraint(equalToConstant: 44),
            
            startYearTitleLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 25),
            startYearTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            startYearLabel.topAnchor.constraint(equalTo: startYearTitleLabel.bottomAnchor, constant: 5),
            startYearLabel.leadingAnchor.constraint(equalTo: startYearTitleLabel.leadingAnchor),
            
            firstSeparator.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            firstSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4 + 25),
            firstSeparator.bottomAnchor.constraint(equalTo: startYearLabel.bottomAnchor),
            firstSeparator.widthAnchor.constraint(equalToConstant: 2),
            
            modificationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modificationTitleLabel.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            modificationDateLabel.topAnchor.constraint(equalTo: startYearLabel.topAnchor),
            modificationDateLabel.centerXAnchor.constraint(equalTo: modificationTitleLabel.centerXAnchor),
            
            secondSeparator.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            secondSeparator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4 - 25),
            secondSeparator.bottomAnchor.constraint(equalTo: startYearLabel.bottomAnchor),
            secondSeparator.widthAnchor.constraint(equalToConstant: 2),
            
            endYearTitleLabel.topAnchor.constraint(equalTo: startYearTitleLabel.topAnchor),
            endYearTitleLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            endYearLabel.topAnchor.constraint(equalTo: startYearLabel.topAnchor),
            endYearLabel.trailingAnchor.constraint(equalTo: endYearTitleLabel.trailingAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: startYearLabel.bottomAnchor, constant: 50),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        ])
    }
}
