//
//  FeedItemDataModel.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct ImageUrls: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}

struct FeedListDataModel: Decodable {
    let results: [FeedItemDataModel]
}

struct FeedItemDataModel: Decodable {
    let id: String
    let urls: ImageUrls
    let description: String?
    let alt_description: String?
}
