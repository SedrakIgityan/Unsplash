//
//  FeedDetailsDataModel.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedDetailsDataModel: Decodable {
    struct Location: Decodable {
        let city: String?
        let country: String?
    }
    
    struct User: Decodable {
        let id: String
        let username: String
        let name: String
    }
    
    let id: String
    let created_at: String
    let description: String?
    let alt_description: String?
    let location: Location?
    let user: User
    let urls: ImageUrls
    let liked_by_user: Bool
}
