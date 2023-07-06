//
//  APIConfig.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 01/07/2023.
//

import Foundation
import CryptoKit

func MD5(of data: String) -> String {
    let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
    
    return hash.map {
        String(format: "%02hhx", $0)
    }.joined()
}

let url = URL(string: "http://gateway.marvel.com/v1/public/comics?ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05&format=comic&noVariants=false&hasDigitalIssue=true&orderBy=title")
let publicKey = "96cfa48ca9c0a2e2273c897356ba5f37"
let privateKey = "77d97c0de2fdea9d41f80aba6e86069f7d5bb7ab"
let timestamp = "1"
let hash = "177d97c0de2fdea9d41f80aba6e86069f7d5bb7ab96cfa48ca9c0a2e2273c897356ba5f37"

let testUrl = "http://gateway.marvel.com/v1/public/comics/49008?ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"

let comicsOrderedByTitleUrlString = "https://gateway.marvel.com:443/v1/public/comics?format=comic&formatType=comic&hasDigitalIssue=false&orderBy=title&ts=1&apikey=96cfa48ca9c0a2e2273c897356ba5f37&hash=18ee522a7cc80757a01ca3bb79608f05"
