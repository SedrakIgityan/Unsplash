//
//  RequestBuilder.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

final class RequestBuilder: RequestBuildable {
    struct BuildError: Error {}
    
    func build(_ api: API) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = api.base
        components.path = api.path
        
        if let query = api.query {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        if let url = components.url {
            var request = URLRequest(url: url)
            
            request.httpBody = api.encoder?.encode()
            request.httpMethod = api.httpMethod.rawValue
            
            return request
        }
        
        throw BuildError()
    }
}
