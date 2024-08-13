//
//  ViewController.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import UIKit

final class FeedViewController: UIViewController {
    enum FeedSection: Hashable {
        case main
    }
    
    var onLoad: (() -> Void)?
    var collectionDelegate: (() -> UICollectionViewDelegate)?
    var refreshControl: (() -> UIRefreshControl)?
    var searchController: (() -> UISearchController)?
    var searchPerformed: ((String) -> Void)?

    var loadImage: ((FeedCollectionViewCell, URL) -> Void)?

    private weak var collectionView: UICollectionView?
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<FeedSection, FeedItem>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        onLoad?()
    }
    
    func currentSnapshot() -> NSDiffableDataSourceSnapshot<FeedSection, FeedItem>? {
        return collectionViewDataSource?.snapshot()
    }
    
    private func setupUI() {
        setupCollectionView()
        navigationItem.searchController = searchController?()
        navigationItem.searchController?.searchResultsUpdater = self
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        setupDataSource(collectionView)
    }
    
    private func setupDataSource(_ collectionView: UICollectionView) {
        let cellRegistration = provideCellRegistration()
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        collectionView.delegate = collectionDelegate?()
        collectionView.refreshControl = refreshControl?()
    }
    
    private func provideCellRegistration() -> UICollectionView.CellRegistration<FeedCollectionViewCell, FeedItem> {
        return UICollectionView.CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            cell.setup(itemIdentifier)
            self?.loadImage?(cell, itemIdentifier.imagePath)
        }
    }
    
    private func apply(_ snapshot: NSDiffableDataSourceSnapshot<FeedSection, FeedItem>) {
        collectionViewDataSource?.apply(snapshot)
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchPerformed?(searchController.searchBar.text ?? "")
    }
}

extension FeedViewController: ErrorView, FeedView {
    func snaphsot() -> NSDiffableDataSourceSnapshot<FeedSection, FeedItem>? {
        collectionViewDataSource?.snapshot()
    }
    
    func display(_ error: Error) {
        
    }
    
    func displayImageError(_ error: Error) {
        
    }
    
    func displayImage(_ data: Data, cell: FeedCollectionViewCell) {
        cell.imageResult?(data)
    }
    
    func display(_ snapshot: NSDiffableDataSourceSnapshot<FeedSection, FeedItem>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.refreshControl?().endRefreshing()
        }
        
        apply(snapshot)
    }
}
