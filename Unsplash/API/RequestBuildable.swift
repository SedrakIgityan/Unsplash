//
//  RequestBuildable.swift
//  Unsplash
//
//  Created by Sedrak Igityan on 5/31/24.
//

import Foundation

protocol RequestBuildable {
    func build(_ api: API) throws -> URLRequest
}
