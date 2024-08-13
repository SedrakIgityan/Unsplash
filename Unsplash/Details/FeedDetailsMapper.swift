//
//  FeedDetailsMapper.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedDetailsMapper {
    struct FeedDetailsError: Error {}
    
    static func map(_ response: URLResponse?, data: Data?, error: Error?) throws -> FeedDetails {
        if let error {
            throw error
        }
        
        if let data {
            let model = try JSONDecoder().decode(FeedDetailsDataModel.self, from: data)
            let fromDateFormatter = ISO8601DateFormatter()
            
            guard let date = fromDateFormatter.date(from: model.created_at) else {
                throw FeedDetailsError()
            }
            
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateStyle = .medium
            
            let createdAt = toDateFormatter.string(from: date)
            
            let author = FeedDetails.Author(name: model.user.name)
            
            let locationName = "City: \(model.location?.city ?? "No City"), Country: \(model.location?.country ?? "No Country")"
            let location = FeedDetails.Location(name: locationName)
            
            return FeedDetails(id: model.id,
                               description: model.description ?? model.alt_description ?? "No info",
                               createdAt: createdAt,
                               author: author,
                               location: location, 
                               isLiked: model.liked_by_user)
        }
        
        throw FeedDetailsError()
    }
}
