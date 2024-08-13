//
//  FeedDetailsViewModel.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation
import Combine

protocol FeedDetailsView: AnyObject {
    func displayImage(_ data: Data)
    func diplayDetails(_ details: FeedDetails)
    func displayLikeChange(_ isLike: Bool)
}

protocol FeedDetailsErrorView: AnyObject {
    func displayError(_ error: Error)
}

final class FeedDetailsViewModel {
    var cancelables = Set<AnyCancellable>()
    
    private let item: FeedItem
    private var isLiked: Bool = false
    
    var imageLoad: ((URL) -> AnyPublisher<Data, Error>)?
    var feedLoad: ((String) -> AnyPublisher<FeedDetails, Error>)?
    var likeLoad: ((Bool, String) -> AnyPublisher<Void, Error>)?

    weak var view: FeedDetailsView?
    weak var errorView: FeedDetailsErrorView?

    init(item: FeedItem,
         view: FeedDetailsView,
         errorView: FeedDetailsErrorView) {
        self.item = item
        self.view = view
        self.errorView = errorView
    }
    
    func load() {
        feedLoad?(item.id).receive(on: DispatchQueue.main).sink(receiveCompletion: { error in
            if case .failure(let error) = error {
                self.errorView?.displayError(error)
            }
        }, receiveValue: { details in
            self.view?.diplayDetails(details)
        }).store(in: &cancelables)
    }
    
    func loadImage() {
        imageLoad?(item.imagePath).receive(on: DispatchQueue.main).sink(receiveCompletion: { error in
            if case .failure(let error) = error {
                self.errorView?.displayError(error)
            }
        }, receiveValue: { data in
            self.view?.displayImage(data)
        }).store(in: &cancelables)
    }
    
    func like() {
        likeLoad?(isLiked, item.id)
            .receive(on: DispatchQueue.main).sink(receiveCompletion: { error in
            if case .failure(let error) = error {
                self.errorView?.displayError(error)
            }
        }, receiveValue: { isLiked in
            self.isLiked.toggle()
            self.view?.displayLikeChange(self.isLiked)
        }).store(in: &cancelables)
    }
}
