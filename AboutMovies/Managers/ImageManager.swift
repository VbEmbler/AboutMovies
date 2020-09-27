//
//  ImageManager.swift
//  AboutMovies
//
//  Created by Vladimir on 24/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import Foundation

class ImageManager{
    
    //MARK: - Public Properties
    static let shared = ImageManager()
    
    //MARK: - Initializers
    private init() {}
    
    //Public Methods
    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
    
}
