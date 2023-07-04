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
    let pageCount: Int?
    let format: String?
    let thumbnail: ComicImage?
    let images: [ComicImage]?
    let dates: [ComicDate]?
}

struct ComicImage: Codable {
    let path: String?
    let `extension`: String?
}

struct ComicDate: Codable {
    let type: String?
    let date: String?
}
