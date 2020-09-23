//
//  Movie.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

struct Film: Decodable {
    let filmId: Int?
    let nameRu: String?
    let nameEn: String?
    let year: Int?
    let posterUrl: String?
    let posterUrlPreview: String?
    let filmLength: String?
    let ratingAgeLimits: Int?
    let premiereWorld: String?
    let slogan: String?
    let description: String?
    let countries: [Country]
    let genres: [Genre]
}
