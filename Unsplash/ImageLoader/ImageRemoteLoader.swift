//
//  ImageRemoteLoader.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import Foundation
import Combine

final class ImageRemoteLoader: ImageLoadable {
    let urlSession: URLSession
    let url: URL
    
    struct ImageRemoteLoaderError: Error {}
    
    init(urlSession: URLSession, url: URL) {
        self.urlSession = urlSession
        self.url = url
    }
    
    func load() -> AnyPublisher<Data, Error> {
        return Deferred {
            Future { promise in
                self.urlSession.dataTask(with: URLRequest(url: self.url), completionHandler: { data, response, error in
                    if let data {
                        return promise(.success(data))
                    }
                    
                    if let error {
                        return promise(.failure(error))
                    }
                    
                    return promise(.failure(ImageRemoteLoaderError()))
                }).resume()
            }
        }.eraseToAnyPublisher()
    }
}
