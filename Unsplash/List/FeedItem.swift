//
//  FeedItem.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedItem: Hashable {
    let id: String
    let description: String?
    let imagePath: URL
}
