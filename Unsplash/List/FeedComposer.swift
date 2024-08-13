//
//  FeedComposer.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import UIKit
import Combine

struct FeedComposer {
    static func compose(fetchFeedPublisher: @escaping (FeedInput) -> AnyPublisher<[FeedItem], Error>,
                        loadImagePublisher: @escaping (URL, UICollectionViewCell) -> AnyPublisher<Data, Error>) -> UIViewController {
        let controller = FeedViewController()
        let viewModel = FeedViewModel(view: controller, errorView: controller)
        let collectionDelegate = FeedListCollectionWrapper(currentSnapshot: controller.currentSnapshot)
        let searchController = UISearchController(searchResultsController: nil)
        let coordinator = FeedViewCoordinator()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(.init(handler: { _ in
            viewModel.loadInitial()
        }), for: .valueChanged)

        collectionDelegate.itemTapped = { item in
            coordinator.itemTapped(item, showLikeButton: true)
        }
        
        collectionDelegate.loadMore = {
            viewModel.loadMore()
        }
        
        viewModel.imageLoad = { url, cell in
            return loadImagePublisher(url, cell)
        }

        viewModel.load = { input in
            return fetchFeedPublisher(input)
        }
        
        controller.title = "Feed"
        
        coordinator.viewController = controller
        
        controller.onLoad = {
            viewModel.loadInitial()
        }
        
        controller.loadImage = { cell, url in
            viewModel.loadImage(url: url, cell: cell)
        }
        
        controller.searchPerformed = { text in
            viewModel.loadSearch(searchText: text)
        }
        
        controller.collectionDelegate = {
            return collectionDelegate
        }
        
        controller.refreshControl = {
            return refreshControl
        }
        
        controller.searchController = {
            return searchController
        }
        
        return controller
    }
}
