//
//  ModelImageManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 06/07/2023.
//

import Foundation

class ModelImageManager {
    
    static let shared = ModelImageManager()
    
    func getImageData(for image: APIImage?, completionBlock: @escaping (Data) -> Void) {
        guard let image = image else { return }
        if let imagePath = image.path {
            if let imageExtension = image.extension {
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
