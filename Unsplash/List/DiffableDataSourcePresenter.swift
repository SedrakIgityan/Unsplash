//
//  DiffableDataSourcePresenter.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/2/24.
//

import UIKit

struct FeedDiffableDataSourcePresenter {
    static func createSnapshot(from current: NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>,
                               appending items: [FeedItem],
                               input: FeedInput) -> NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem> {
        var currentSnapshot: NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>
        
        if input.isReset {
            currentSnapshot = NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>()
            currentSnapshot.appendSections([.main])
        } else {
            currentSnapshot = current
        }
        
        currentSnapshot.appendItems(items)
        
        return currentSnapshot
    }
}
