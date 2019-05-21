//
//  LocalFileImageDataProvider.swift
//  Chefie
//
//  Created by Steven on 28/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Kingfisher

struct LocalFileImageDataProvider: ImageDataProvider {
    let fileURL: URL
    public var cacheKey: String
    
    init(fileURL: URL, cacheKey: String? = nil) {
        self.fileURL = fileURL
        self.cacheKey = cacheKey ?? fileURL.absoluteString
    }
    
    func data(handler: (Result<Data, Error>) -> Void) {
        handler( Result { try Data(contentsOf: fileURL) } )
    }
}
