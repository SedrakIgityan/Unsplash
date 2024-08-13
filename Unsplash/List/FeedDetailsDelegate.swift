//
//  FeedListCollectionWrapper.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import UIKit

final class FeedListCollectionWrapper: NSObject, UICollectionViewDelegate {
    var itemTapped: ((FeedItem) -> Void)?
    var loadMore: (() -> Void)?
    
    let currentSnapshot: (() -> NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>?)
    
    init(currentSnapshot: @escaping () -> NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>?) {
        self.currentSnapshot = currentSnapshot
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = currentSnapshot()?.itemIdentifiers.count else { return }

        if indexPath.item == count - 3 {
            loadMore?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = currentSnapshot()?.itemIdentifiers[indexPath.item] else { return }
        
        itemTapped?(item)
    }
}
