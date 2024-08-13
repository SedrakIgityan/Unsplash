//
//  FeedCollectionViewCell.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {
    private weak var imageView: UIImageView!
    private weak var descriptionLabel: UILabel!
    
    var imageResult: ((Data) -> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    private func initialize() {
        let imageView = UIImageView()
        let label = UILabel()
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)

        label.numberOfLines = 3
        
        self.imageView = imageView
        self.descriptionLabel = label
        
        layoutImageView(imageView, with: label)
        layoutLabel(label, with: imageView)
    }
    
    private func layoutImageView(_ imageView: UIImageView, with label: UILabel) {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        let imageTopConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        let imageBottomConstraint = contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        
        imageTopConstraint.isActive = true
        imageBottomConstraint.isActive = true
        imageTopConstraint.priority = .defaultLow
        imageBottomConstraint.priority = .defaultLow
    }
    
    private func layoutLabel(_ label: UILabel, with imageView: UIImageView) {
        label.translatesAutoresizingMaskIntoConstraints = false

        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
    }
    
    func setup(_ item: FeedItem) {
        self.descriptionLabel.text = item.description
        imageResult = { [weak self] data in
            self?.imageView.image = UIImage(data: data)
        }
    }
}
