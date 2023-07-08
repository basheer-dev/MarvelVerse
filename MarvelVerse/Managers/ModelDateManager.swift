//
//  ModelDateTextManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 06/07/2023.
//

import Foundation

class ModelDateManager {
    
    static let shared = ModelDateManager()
    let ISODateFormatter = ISO8601DateFormatter()
    let dateFormatter = DateFormatter()
    
    
    func getYear(from year: Int?) -> String {
        guard let year = year else { return "N/A"}
        
        return String(year)
    }
    
    
    func getDate(from dateString: String?, getYearOnly: Bool = false) -> String {
        if let dateString = dateString {
            if let date = ISODateFormatter.date(from: dateString) {
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                let day = Calendar.current.component(.day, from: date)
                
                if getYearOnly {
                    return String(year)
                }
                
                return String(format: "%02d/%02d/%02d", day, month, year)
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                if let date = dateFormatter.date(from: dateString) {
                    let year = Calendar.current.component(.year, from: date)
                    let month = Calendar.current.component(.month, from: date)
                    let day = Calendar.current.component(.day, from: date)
                    
                    if getYearOnly {
                        return String(year)
                    }
                    
                    return String(format: "%02d/%02d/%02d", day, month, year)
                }
            }
        }
        
        return "N/A"
    }
    
    
    func getPubDate(from dates: [APIDate]?) -> String {
        // Used with comics only
        
        guard let dates = dates else { return "N/A"}
        
        for date in dates {
            if date.type == "onsaleDate" {
                if let dateString = date.date {
                    if let pubDate = ISODateFormatter.date(from: dateString) {
                        let year = Calendar.current.component(.year, from: pubDate)
                        let month = Calendar.current.component(.month, from: pubDate)
                        let day = Calendar.current.component(.day, from: pubDate)
                        
                        return String(format: "%02d/%02d/%02d", day, month, year)
                    }
                    
                }
            }
        }
        
        return "N/A"
    }
}
