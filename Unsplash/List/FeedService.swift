//
//  FeedService.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation
import Combine

final class FeedService {
    let urlSession: URLSession
    let requestBuilder: RequestBuildable
    
    init(urlSession: URLSession, requestBuilder: RequestBuildable) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
    
    func fetchFeed(from page: Int, searchQuery: String) -> AnyPublisher<[FeedItem], Error> {
        let api = FeedAPI(page: page, searchQuery:  searchQuery)
        
        return Deferred {
            Future { promise in
                do {
                    let request = try self.requestBuilder.build(api)

                    self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
                        do {
                            let result = try FeedMapper.map(response, data: data, error: error)
                            
                            promise(.success(result))
                        } catch {
                            promise(.failure(error))
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

