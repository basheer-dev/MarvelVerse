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
    
    
    func getAPIUserKeyInfo() -> String {
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
    
    
    func getURL(from urls: [APIUrl]?, isDetailsURL: Bool = false, isPurchaseURL: Bool = false, isComicsURL: Bool = false) -> String {
        guard let urls = urls else { return "" }
        
        for url in urls {
            if let urlType = url.type {
                if let urlPath = url.url {
                    if urlType == "detail" && isDetailsURL {
                        return urlPath.replacingOccurrences(of: "http://", with: "https://")
                    } else if urlType == "purchase" && isPurchaseURL {
                        return urlPath.replacingOccurrences(of: "http://", with: "https://")
                    } else if urlType == "comiclink" && isComicsURL {
                        return urlPath.replacingOccurrences(of: "http://", with: "https://")
                    }
                }
            }
        }
        
        return ""
    }
}
