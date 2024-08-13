//
//  LikeListAPI.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import Foundation

struct LikeListAPI: API {
    var base: String = "api.unsplash.com"
    
    var path: String {
        "/users/\(username)/likes"
    }
    
    var query: [String : String]? {
        return [
            "page": String(page),
            "per_page": "30",
        ]
    }
    var encoder: RequestEncoder? = nil
    var httpMethod: HTTPMethod = .get
    
    let username: String
    let page: Int
}
