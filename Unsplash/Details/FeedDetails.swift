//
//  FeedDetails.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedDetails {
    struct Author {
        let name: String
    }
    
    struct Location {
        let name: String
    }
    
    let id: String
    let description: String
    let createdAt: String
    let author: Author
    let location: Location
    let isLiked: Bool
}
