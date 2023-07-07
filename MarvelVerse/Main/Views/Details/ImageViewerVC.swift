//
//  ImageViewerVC.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 07/07/2023.
//

import UIKit

class ImageViewerVC: UIViewController {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.configuration = .tinted()
        button.configuration?.image = UIImage(systemName: "square.and.arrow.up")
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.baseForegroundColor = .systemGreen
        
        return button
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(applyZoom))
        imageView.addGestureRecognizer(pinchGesture)
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(imageView)
        
        view.addSubview(scrollView)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -15),
            
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 75),
            shareButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - ACTIONS
    @objc private func shareImage() {
        
    }
    
    @objc private func applyZoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width * sender.scale, height: scrollView.frame.height * sender.scale)
            imageView.center = scrollView.center
        }
    }
}
