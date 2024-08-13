//
//  FeedViewModel.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation
import UIKit
import Combine

struct FeedInput {
    let page: Int
    let search: String
    let isReset: Bool
}

protocol FeedView: AnyObject {
    func display(_ snapshot: NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>)
    func displayImage(_ data: Data, cell: FeedCollectionViewCell)
    func snaphsot() -> NSDiffableDataSourceSnapshot<FeedViewController.FeedSection, FeedItem>?
}

protocol ErrorView: AnyObject {
    func display(_ error: Error)
    func displayImageError(_ error: Error)
}

final class FeedViewModel {
    var cancelables = Set<AnyCancellable>()
    var load: ((FeedInput) -> AnyPublisher<[FeedItem], Error>)?
    var imageLoad: ((URL, FeedCollectionViewCell) -> AnyPublisher<Data, Error>)?

    weak var view: FeedView?
    weak var errorView: ErrorView?
    
    init(view: FeedView, errorView: ErrorView) {
        self.view = view
        self.errorView = errorView
    }

    private var currentPage: Int = 1
    private var searchText: String = "''"
    
    func loadImage(url: URL, cell: FeedCollectionViewCell) {
        imageLoad?(url, cell)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    self.errorView?.displayImageError(error)
                }
            }, receiveValue: {
                self.view?.displayImage($0, cell: cell)
            }).store(in: &cancelables)
    }
    
    func loadSearch(searchText: String) {
        currentPage = 1
        self.searchText = searchText.isEmpty ? "''" : searchText
        load(.init(page: currentPage, search: self.searchText.lowercased(), isReset: true))
    }
    
    func loadInitial() {
        currentPage = 1
        load(.init(page: currentPage, search: searchText, isReset: true))
    }
    
    func loadMore() {
        currentPage += 1
        load(.init(page: currentPage, search: searchText, isReset: false))
    }

    private func load(_ input: FeedInput) {
        self.load?(input)
            .receive(on: DispatchQueue.main)
            .tryMap({ items in
                guard let currentSnapshot = self.view?.snaphsot() else { throw FeedMapper.FeedError() }
                
                let snapshot = FeedDiffableDataSourcePresenter.createSnapshot(from: currentSnapshot,
                                                                              appending: items,
                                                                              input: input)
                return snapshot
            })
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    self.errorView?.display(error)
                }
            }, receiveValue: {
                self.view?.display($0)
            })
            .store(in: &cancelables)
    }
}
