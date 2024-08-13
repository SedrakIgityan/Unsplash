//
//  FeedDetailsViewController.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import UIKit

final class FeedDetailsViewController: UIViewController {
    var onLoad: (() -> Void)?
    var likeTapped: (() -> Void)?
    var loadImage: (() -> Void)?
    
    var showLikeButton = false

    private weak var imageView: UIImageView?
    private weak var createdAtLabel: UILabel?
    private weak var authorLabel: UILabel?
    private weak var locationLabel: UILabel?
    private weak var descriptionLabel: UILabel?
    private weak var likeButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        onLoad?()
        loadImage?()
    }
    
    private func updateButton(_ isLiked: Bool) {
        let likeResource = (isLiked) ? "hand.thumbsup.fill" : "hand.thumbsup"
        likeButton?.setImage(UIImage(systemName: likeResource), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let containerStack = UIStackView()
        containerStack.spacing = 10
        containerStack.axis = .vertical
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        layoutImageView(imageView, in: imageContainerView)

        let createdAtLabel = UILabel()
        let authorLabel = UILabel()
        let locationLabel = UILabel()
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        
        let likeButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            self?.likeTapped?()
        }))
        likeButton.isUserInteractionEnabled = false
        
        containerStack.addArrangedSubview(imageContainerView)
        containerStack.addArrangedSubview(createdAtLabel)
        containerStack.addArrangedSubview(authorLabel)
        containerStack.addArrangedSubview(descriptionLabel)
        containerStack.addArrangedSubview(locationLabel)
        
        if showLikeButton {
            containerStack.addArrangedSubview(likeButton)
        }
        
        self.imageView = imageView
        self.createdAtLabel = createdAtLabel
        self.authorLabel = authorLabel
        self.locationLabel = locationLabel
        self.descriptionLabel = descriptionLabel
        self.likeButton = likeButton
        
        view.addSubview(containerStack)
        pinContainer(containerStack)
    }
    
    private func pinContainer(_ containerStack: UIStackView) {
        containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor, constant: 15).isActive = true
        containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: containerStack.bottomAnchor,
                                               constant: 15).isActive = true
    }
    
    private func layoutImageView(_ imageView: UIImageView, in imageContainerView: UIView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leadingAnchor).isActive = true
        imageContainerView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(greaterThanOrEqualTo: imageView.trailingAnchor).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension FeedDetailsViewController: FeedDetailsErrorView, FeedDetailsView {
    func displayError(_ error: Error) {
        
    }
    
    func displayImage(_ data: Data) {
        imageView?.image = UIImage(data: data)
    }
    
    func diplayDetails(_ details: FeedDetails) {
        createdAtLabel?.text = "Created at: " + details.createdAt
        authorLabel?.text = "Author: " + details.author.name
        locationLabel?.text = details.location.name
        descriptionLabel?.text = "Description: " + details.description
        
        let likeResource = (details.isLiked) ? "hand.thumbsup.fill" : "hand.thumbsup"
        likeButton?.isUserInteractionEnabled = true
        likeButton?.setTitle("Like", for: .normal)
        updateButton(details.isLiked)
    }
    
    func displayLikeChange(_ isLike: Bool) {
        updateButton(isLike)
    }
}
