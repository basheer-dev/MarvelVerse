//
//  ModelDateTextManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 06/07/2023.
//

import Foundation

class ModelDateManager {
    
    static let shared = ModelDateManager()
    let dateFormatter = ISO8601DateFormatter()
    
    
    func getYear(from year: Int?) -> String {
        guard let year = year else { return "Not Defined"}
        
        return String(year)
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
}
