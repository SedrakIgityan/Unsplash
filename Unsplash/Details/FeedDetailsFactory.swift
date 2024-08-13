//
//  FeedDetailsFactory.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/3/24.
//

import UIKit

protocol FeedDetailsFactory {
    func makeDetails(_ input: FeedDetailsInput) -> UIViewController
}

final class FeedDetailsProvider: FeedDetailsFactory {
    func makeDetails(_ input: FeedDetailsInput) -> UIViewController {
        let feedDetailsService = FeedDetailsService(urlSession: .shared,
                                                    requestBuilder: AuthorizedBuilder(builder: RequestBuilder()))
        let likeService = FeedLikeService(urlSession: .shared,
                                                    requestBuilder: AuthorizedBuilder(builder: RequestBuilder()))
        
        return FeedDetailsComposer.compose(input) { id in
            feedDetailsService.fetchFeed(from: id)
        } likeLoadPublisher: { isLiked, id in
            likeService.toggleLike(from: id, isLike: isLiked)
        } loadImagePublisher: { url in
            let imageLoader = ImageRemoteLoader(urlSession: .shared, url: url)

            return imageLoader.load()
        }
    }
}
