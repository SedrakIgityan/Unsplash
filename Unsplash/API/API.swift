//
//  API.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

protocol API {
    var base: String { get }
    var path: String { get }
    var query: [String: String]? { get }
    var encoder: RequestEncoder? { get }
    var httpMethod: HTTPMethod { get }
}

protocol RequestEncoder {
    func encode() -> Data
}

enum HTTPMethod: String {
    case put = "PUT"
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}
