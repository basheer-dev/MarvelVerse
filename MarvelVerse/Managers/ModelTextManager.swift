//
//  APITextManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 06/07/2023.
//

import Foundation

class ModelTextManager {
    
    static let shared = ModelTextManager()
    
    
    func getTitle(from title: String?) -> String {
        guard let title = title else { return "No Available Title" }
        
        if !title.isEmpty {
            return title.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
        }
        
        return "No Available Title"
    }
    
    
    func getDescription(from description: String?) -> String {
        guard let description = description,
              !description.isEmpty else { return "No Available Description"}
        
        return description.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&ndash;", with: "&").trimmingCharacters(in: .newlines).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    
    func getStringInfo(from info: String?) -> String {
        // Used for type and rating in series
        guard let info = info else { return "Not Defined" }
        
        if !info.isEmpty {
            return info
        }
        
        return "Not Defined"
    }
    
    
    func getPrice(from prices: [APIPrice]?, isPrintPrice: Bool = false, isDigitalCopyPrice: Bool = false) -> String {
        guard let prices = prices else { return "N/A"}
        
        for price in prices {
            guard let priceType = price.type,
                  let priceValue = price.price else { return "N/A"}
            
            if priceValue > 0.0 {
                if isPrintPrice && priceType == "printPrice" {
                    return String(format: "$ %.2f", priceValue)
                } else if isDigitalCopyPrice && priceType == "digitalPurchasePrice" {
                    return String(format: "$ %.2f", priceValue)
                }
            }
        }
        
        return "N/A"
    }
}
