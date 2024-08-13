//
//  LikeFeedMapper.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import Foundation

struct LikeFeedMapper {
    struct FeedError: Error {}
    static func map(_ response: URLResponse?, data: Data?, error: Error?) throws -> [FeedItem] {
        if let error {
            throw error
        }
        
        if let data {
            let items = try JSONDecoder().decode([FeedItemDataModel].self, from: data)
            
            return items.map { model in
                return FeedItem(id: model.id,
                                description: model.description ?? model.alt_description ?? "No info",
                                imagePath: model.urls.thumb)
            }
        }
        
        throw FeedError()
    }
}
