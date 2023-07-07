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
        
        return description.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&ndash;", with: "&").replacingOccurrences(of: "32 PGS./MARVEL PSR...$3.50", with: "").replacingOccurrences(of: "32 PGS./Rated A ...$2.99", with: "").replacingOccurrences(of: "<br>", with: "").trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .newlines)
    }
    
    
    func getStringInfo(from info: String?) -> String {
        // Used for type and rating in series
        guard let info = info else { return "Not Defined" }
        
        if !info.isEmpty {
            return info
        }
        
        return "Not Defined"
    }
}
