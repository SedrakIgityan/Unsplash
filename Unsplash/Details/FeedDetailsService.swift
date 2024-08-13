//
//  FeedDetailsService.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import Foundation
import Combine

final class FeedDetailsService {
    let urlSession: URLSession
    let requestBuilder: RequestBuildable
    
    init(urlSession: URLSession, requestBuilder: RequestBuildable) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
    
    func fetchFeed(from id: String) -> AnyPublisher<FeedDetails, Error> {
        let api = FeedDetailsAPI(id: id)
        
        return Deferred {
            Future { promise in
                do {
                    let request = try self.requestBuilder.build(api)

                    self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
                        do {
                            let result = try FeedDetailsMapper.map(response, data: data, error: error)
                            
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

