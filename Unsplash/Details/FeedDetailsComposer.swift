//
//  FeedDetailsComposer.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import UIKit
import Combine

struct FeedDetailsComposer {
    static func compose(_ input: FeedDetailsInput,
                        fetchFeedPublisher: @escaping (String) -> AnyPublisher<FeedDetails, Error>,
                        likeLoadPublisher: @escaping (Bool, String) -> AnyPublisher<Void, Error>,
                        loadImagePublisher: @escaping (URL) -> AnyPublisher<Data, Error>) -> UIViewController {
        let controller = FeedDetailsViewController()

        let viewModel = FeedDetailsViewModel(item: input.item,
                                             view: controller,
                                             errorView: controller)
        
        viewModel.feedLoad = { item in
            fetchFeedPublisher(item)
        }
        
        viewModel.imageLoad = { url in
            loadImagePublisher(url)
        }
        
        viewModel.likeLoad = { isLiked, path in
            likeLoadPublisher(isLiked, path)
        }

        controller.title = "Details"
        controller.showLikeButton = input.showLike
        
        controller.likeTapped = viewModel.like
        
        controller.onLoad = {
            viewModel.load()
        }
        
        controller.loadImage = {
            viewModel.loadImage()
        }
        
        return controller
    }
}
