//
//  FeedMapper.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedMapper {
    struct FeedError: Error {}
    static func map(_ response: URLResponse?, data: Data?, error: Error?) throws -> [FeedItem] {
        if let error {
            throw error
        }
        
        if let data {
            let dataModel = try JSONDecoder().decode(FeedListDataModel.self, from: data)
            
            return dataModel.results.map { model in
                return FeedItem(id: model.id,
                                description: model.description ?? model.alt_description ?? "No info",
                                imagePath: model.urls.thumb)
            }
        }
        
        throw FeedError()
    }
}
