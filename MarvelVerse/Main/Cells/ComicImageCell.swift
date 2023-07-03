//
//  ComicImageCell.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import UIKit

class ComicImageCell: UICollectionViewCell {
    static let id: String = "ComicImageContainer"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SUBVIEWS
    private func configureSubviews() {
        imageView.frame = bounds
        addSubview(imageView)
    }
}
