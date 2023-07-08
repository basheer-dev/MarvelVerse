//
//  Events.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 08/07/2023.
//

import Foundation

struct Events: Codable {
    let data: EventsData
}

struct EventsData: Codable {
    let results: [Event]
}

struct Event: Codable {
    let id: Int
    let title: String?
    let description: String?
    let modified: String?
    let start: String?
    let end: String?
    let thumbnail: APIImage?
    let next: APIObject?
    let previous: APIObject?
    let urls: [APIUrl]?
}
