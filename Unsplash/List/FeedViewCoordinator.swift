//
//  FeedViewCoordinator.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import UIKit

final class FeedViewCoordinator {
    weak var viewController: UIViewController?
    
    func itemTapped(_ item: FeedItem, showLikeButton: Bool) {
        let input = FeedDetailsInput(item: item, showLike: showLikeButton)
        let details = FeedDetailsProvider()
        
        viewController?.navigationController?.pushViewController(details.makeDetails(input),
                                                                 animated: true)
    }
}
