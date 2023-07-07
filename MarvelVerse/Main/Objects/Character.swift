//
//  Character.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 07/07/2023.
//

import Foundation

struct Characters: Codable {
    let data: CharactersData
}

struct CharactersData: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: APIImage?
}
