//
//  MainCoordinator.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import UIKit

protocol MainViewControllerFactory {
    func makeTabBarController() -> UITabBarController
    func makeFeedViewController() -> UIViewController
    func makeListViewController() -> UIViewController
}

final class MainCoordinator {
    private let factory: MainViewControllerFactory
    private let navigationController: UINavigationController

    init(factory: MainViewControllerFactory, navigationController: UINavigationController) {
        self.factory = factory
        self.navigationController = navigationController
    }

    func start() {
        let feed = factory.makeFeedViewController()
        let list = factory.makeListViewController()
        let tabBar = factory.makeTabBarController()

        tabBar.setViewControllers([
            UINavigationController(rootViewController: feed),
            UINavigationController(rootViewController: list)
        ], animated: true)

        navigationController.setViewControllers([tabBar], animated: true)
    }
}

final class MainViewControllerProvider: MainViewControllerFactory {

    func makeTabBarController() -> UITabBarController {
        UITabBarController()
    }
    
    func makeFeedViewController() -> UIViewController {
        let feedService = FeedService(urlSession: .shared,
                                          requestBuilder: AuthorizedBuilder(builder: RequestBuilder()))
        
        return FeedComposer.compose(fetchFeedPublisher: { input in
            feedService.fetchFeed(from: input.page, searchQuery: input.search)
        }, loadImagePublisher: { url, cell in
            let imageLoader = ImageRemoteLoader(urlSession: .shared, url: url)

            return imageLoader.load()
        })
    }
    
    func makeListViewController() -> UIViewController {
        let feedService = LikeListService(urlSession: .shared,
                                          requestBuilder: AuthorizedBuilder(builder: RequestBuilder()))
        return LikeFeedComposer.compose { input in
            feedService.fetchFeed(from: input.page, searchQuery: input.search)
        } imageLoadPublisher: { url, cell in
            let imageLoader = ImageRemoteLoader(urlSession: .shared, url: url)

            return imageLoader.load()
        }
    }
}
