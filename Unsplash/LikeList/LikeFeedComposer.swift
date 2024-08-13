//
//  LikeFeedComposer.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import UIKit
import Combine

struct LikeFeedComposer {
    static func compose(fetchFeedPublisher: @escaping (FeedInput) -> AnyPublisher<[FeedItem], Error>,
                        imageLoadPublisher: @escaping (URL, UICollectionViewCell) -> AnyPublisher<Data, Error>) -> UIViewController {
        let controller = FeedViewController()
        let viewModel = FeedViewModel(view: controller, errorView: controller)
        let collectionDelegate = FeedListCollectionWrapper(currentSnapshot: controller.currentSnapshot)

        let coordinator = FeedViewCoordinator()

        collectionDelegate.itemTapped = { item in
            coordinator.itemTapped(item, showLikeButton: false)
        }

        viewModel.load = { input in
            fetchFeedPublisher(input)
        }
        
        viewModel.imageLoad = { url, cell in
            imageLoadPublisher(url, cell)
        }
        
        controller.title = "Likes"
        coordinator.viewController = controller
        
        controller.onLoad = {
            viewModel.loadInitial()
        }
        
        controller.loadImage = { cell, url in
            viewModel.loadImage(url: url, cell: cell)
        }
        
        controller.collectionDelegate = {
            return collectionDelegate
        }
        
        return controller
    }
}
