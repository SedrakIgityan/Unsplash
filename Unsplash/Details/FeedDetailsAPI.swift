//
//  FeedDetailsAPI.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedDetailsAPI: API {
    var base: String = "api.unsplash.com"
    
    var path: String {
        "/photos/\(id)"
    }
    
    var query: [String : String]? = nil
    
    var encoder: RequestEncoder? = nil
    
    var httpMethod: HTTPMethod = .get
    
    let id: String
}
