//
//  FeedAPI.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

struct FeedAPI: API {
    var base: String = "api.unsplash.com"
    
    var path: String {
        return "/search/photos"
    }
    
    var query: [String : String]? {
        return [
            "page": String(page),
            "per_page": "30",
            "query": searchQuery
        ]
    }
    
    var encoder: RequestEncoder? = nil
    
    var httpMethod: HTTPMethod = .get
    
    let page: Int
    let searchQuery: String
}
