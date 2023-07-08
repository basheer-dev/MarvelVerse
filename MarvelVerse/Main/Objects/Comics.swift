//
//  Comics.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 03/07/2023.
//

import Foundation

struct Comics: Codable {
    let data: ComicsData
}

struct ComicsData: Codable {
    let results: [Comic]
}

struct Comic: Codable {
    let id: Int
    let title: String?
    let description: String?
    let modified: String?
    let pageCount: Int?
    let format: String?
    var thumbnail: APIImage?
    let images: [APIImage]?
    let dates: [APIDate]?
    let prices: [APIPrice]?
    let urls: [APIUrl]?
}
