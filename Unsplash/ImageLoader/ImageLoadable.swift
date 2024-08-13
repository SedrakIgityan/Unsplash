//
//  ImageLoadable.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 6/1/24.
//

import UIKit
import Combine

protocol ImageLoadable {
    func load() -> AnyPublisher<Data, Error>
}
