//
//  AuthorizedService.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import Foundation

final class AuthorizedBuilder: RequestBuildable {
    let builder: RequestBuildable
    let token = "C6F8gFJRJ_RF06JGofIYr1m-LFDbboJo8uxHlFW2EZY"
    
    init(builder: RequestBuildable) {
        self.builder = builder
    }
    
    func build(_ api: API) throws -> URLRequest {
        var request = try builder.build(api)
        
        request.addValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
