//
//  URLManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 04/07/2023.
//

import Foundation
import CryptoKit

class URLManager {
    
    static let shared = URLManager()
    let dateFormatter = ISO8601DateFormatter()
    
    
    func fetchData(from urlString: String, offset: Int = 0, completion: @escaping (Data) -> Void) {
        var urlString = urlString
        urlString += getAPIUserKey()
        urlString += "&limit=20"
        
        if offset > 0 {
            urlString += "&offset=\(offset)"
        }
        
        print(urlString)
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // Ready to parse JSON
                    completion(data)
                }
            }
        }
    }
    
    
    func getAPIUserKey() -> String {
        let ts = String(Int(NSDate().timeIntervalSince1970))
        let publicKey = "96cfa48ca9c0a2e2273c897356ba5f37"
        let privateKey = "77d97c0de2fdea9d41f80aba6e86069f7d5bb7ab"
        let hash = MD5(of: "\(ts)\(privateKey)\(publicKey)")
        
        return "?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    func MD5(of data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
    func getTitle(from title: String?) -> String {
        guard let title = title else { return "No Available Title" }
        
        if !title.isEmpty {
            return title.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        }
        
        return "No Available Title"
    }
    
    
    func getAPIImageData(image: APIImage?, completionBlock: @escaping (Data) -> Void) {
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
    
    
    func getDescription(description: String?) -> String {
        guard let description = description,
              !description.isEmpty else { return "No Available Description"}
        
        return description.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&ndash;", with: "&").replacingOccurrences(of: "32 PGS./MARVEL PSR...$3.50", with: "").replacingOccurrences(of: "32 PGS./Rated A ...$2.99", with: "").replacingOccurrences(of: "<br>", with: "").trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
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
    
    
    func getPubDate(from dates: [APIDate]?) -> String {
        // Used with comics only
        
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
    
    func getYear(from year: Int?) -> String {
        guard let year = year else { return "Not Defined"}
        
        return String(year)
    }
    
    
    func getAPIStringInfo(from info: String?) -> String {
        // Used for type and rating in series
        guard let info = info else { return "Not Defined" }
        
        if !info.isEmpty {
            return info
        }
        
        return "Not Defined"
    }
}
