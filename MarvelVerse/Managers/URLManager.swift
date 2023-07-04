//
//  URLManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 04/07/2023.
//

import Foundation

class URLManager {
    
    static let shared = URLManager()
    let dateFormatter = ISO8601DateFormatter()
    
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
    
    func getDescription(description: String?) -> String {
        guard let description = description,
              !description.isEmpty else { return "No Available Description"}
        
        return description.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&ndash;", with: "&").replacingOccurrences(of: "32 PGS./MARVEL PSR...$3.50", with: "").trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
    }
    
    func getDate(from dateString: String?) -> String {
        if let dateString = dateString {
            if let date = dateFormatter.date(from: dateString) {
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                let day = Calendar.current.component(.day, from: date)
                
                return String(format: "%02d/%02d/%02d", day, month, year)
            }
        }
        
        return "Date Not Defined"
    }
    
    func getPubDate(from dates: [ComicDate]?) -> String {
        guard let dates = dates else { return "Date Not Defined"}
        
        for date in dates {
            if date.type == "onsaleDate" {
                if let dateString = date.date {
                    if let pubDate = dateFormatter.date(from: dateString) {
                        
                        let year = Calendar.current.component(.year, from: pubDate)
                        let month = Calendar.current.component(.month, from: pubDate)
                        let day = Calendar.current.component(.day, from: pubDate)
                        
                        return String(format: "%02d/%02d/%02d", day, month, year)
                    }
                    
                }
            }
        }
        
        return "Date Not Defined"
    }
}
