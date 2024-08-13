//
//  FeedLikeService.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import Foundation
import Combine

final class FeedLikeService {
    let urlSession: URLSession
    let requestBuilder: RequestBuildable
    
    init(urlSession: URLSession, requestBuilder: RequestBuildable) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
    
    func toggleLike(from id: String, isLike: Bool) -> AnyPublisher<Void, Error> {
        let api = LikeAPI(id: id, isLike: isLike)
        
        return Deferred {
            Future { promise in
                do {
                    let request = try self.requestBuilder.build(api)

                    self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }).resume()
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

