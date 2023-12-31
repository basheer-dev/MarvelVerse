//
//  Series.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 05/07/2023.
//

import Foundation

struct AllSeries: Codable {
    let data: SeriesData
}

struct SeriesData: Codable {
    let results: [Series]
}

struct Series: Codable {
    let id: Int
    let title: String?
    let description: String?
    let startYear: Int?
    let endYear: Int?
    let modified: String?
    let rating: String?
    let type: String?
    let thumbnail: APIImage?
    let urls: [APIUrl]?
}
