//
//  CommonAPIData.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 05/07/2023.
//

import Foundation

struct APIImage: Codable {
    var path: String?
    let `extension`: String?
}

struct APIDate: Codable {
    let type: String?
    let date: String?
}
