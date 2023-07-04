//
//  URLManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 04/07/2023.
//

import Foundation

class URLManager {
    
    static let shared = URLManager()
    
    func getComicImageData(comicImage: ComicImage?, completionBlock: @escaping (Data) -> Void) {
        guard let comicImage = comicImage else { return }
        if let imagePath = comicImage.path {
            if let imageExtension = comicImage.extension {
                let imageURLString = imagePath.replacingOccurrences(of: "http://", with: "https://") + "." + imageExtension
                                
                if let imageURL = URL(string: imageURLString) {
                    URLSession.shared.dataTask(with: imageURL) {
                        data, _, error in
                        guard error == nil,
                              let data = data else { return }
                        completionBlock(data)
                    }.resume()
                }
            }
        }
    }
}
