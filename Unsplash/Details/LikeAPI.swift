//
//  LikeAPI.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import Foundation

struct LikeAPI: API {
    var base: String = "api.unsplash.com"
    
    var path: String {
        "/photos/\(id)/like"
    }
    
    var query: [String : String]? = nil
    var encoder: RequestEncoder? = nil
    var httpMethod: HTTPMethod {
        if isLike {
            return .post
        } else {
            return .delete
        }
    }
    
    let id: String
    let isLike: Bool
}
