//
//  DigitalReleaseResponce.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

struct DigitalRelease: Decodable {
    let page: Int?
    let total: Int?
    var releases: [Film]
}
