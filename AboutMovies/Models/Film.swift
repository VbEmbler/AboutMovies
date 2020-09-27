//
//  Movie.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

struct Movie: Decodable {
    let data: Film?
    
    static func getMovie(from value: Any) -> Movie {
        let film = Film.getFilm(from: value)
        return Movie(data: film)
    }
}

struct DigitalRelease: Decodable {
    let page: Int?
    let total: Int?
    var releases: [FilmForRelease]
    
    init(responceData: [String: Any], releasesData: [FilmForRelease]) {
        page = responceData["page"] as? Int
        total = responceData["total"] as? Int
        releases = releasesData
    }
    
    static func getDigitalRelease(from value: Any) -> DigitalRelease? {
        guard let responseData = value as? [String: Any] else { return nil }
        let releases = FilmForRelease.getReleases(from: responseData)
        return DigitalRelease(responceData: responseData, releasesData: releases)
    }
}

struct TopMovie: Decodable {
    let pagesCount: Int?
    var films: [Film]
    
    init(responseData: [String: Any], filmsData: [Film]) {
        pagesCount = responseData["pagesCount"] as? Int
        films = filmsData
    }
    
    static func getTopMovies(from value: Any) -> TopMovie? {
        guard let responseData = value as? [String: Any] else { return nil }
        let movies = Film.getFilms(from: responseData)
        return TopMovie(responseData: responseData, filmsData: movies)
    }
}

struct Film: Decodable {
    let filmId: Int?
    let nameRu: String?
    let nameEn: String?
    let year: String?
    let posterUrl: String?
    let posterUrlPreview: String?
    let filmLength: String?
    let ratingAgeLimits: Int?
    let premiereWorld: String?
    let slogan: String?
    let description: String?
    let rating: String?
    let countries: [Country]
    let genres: [Genre]
    
    init(filmData: [String: Any], countriesData: [Country], genresData: [Genre]) {
        filmId = filmData["filmId"] as? Int
        nameRu = filmData["nameRu"] as? String
        nameEn = filmData["nameEn"] as? String
        year = filmData["year"] as? String
        posterUrl = filmData["posterUrl"] as? String
        posterUrlPreview = filmData["posterUrlPreview"] as? String
        filmLength = filmData["filmLength"] as? String
        ratingAgeLimits = filmData["ratingAgeLimits"] as? Int
        premiereWorld = filmData["premiereWorld"] as? String
        slogan = filmData["slogan"] as? String
        description = filmData["description"] as? String
        rating = filmData["rating"] as? String
        countries = countriesData
        genres = genresData
    }
    
    static func getFilm(from value: Any) -> Film? {
        guard let responseData = value as? [String: Any] else { return nil }
        guard let movieData = responseData["data"] as? [String: Any] else { return nil }
        let countries: [Country] = Country.getCountries(from: movieData)
        let genres: [Genre] = Genre.getGenres(from: movieData)
        return Film(filmData: movieData, countriesData: countries, genresData: genres)
    }
    
    static func getFilms(from responseData: [String: Any]) -> [Film] {
        guard let topMoviesData = responseData["films"] as? [[String: Any]] else { return [] }
        var movies: [Film] = []
        for topMovieData in topMoviesData {
            let countries: [Country] = Country.getCountries(from: topMovieData)
            let genres: [Genre] = Genre.getGenres(from: topMovieData)
            let film = Film(filmData: topMovieData, countriesData: countries, genresData: genres)
            movies.append(film)
        }
        return movies
    }
}

struct FilmForRelease: Decodable {
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
    
    init(releaseData: [String: Any], countriesData: [Country], genresData: [Genre]) {
        filmId = releaseData["filmId"] as? Int
        nameRu = releaseData["nameRu"] as? String
        nameEn = releaseData["nameEn"] as? String
        year = releaseData["year"] as? Int
        posterUrl = releaseData["posterUrl"] as? String
        posterUrlPreview = releaseData["posterUrlPreview"] as? String
        filmLength = releaseData["filmLength"] as? String
        ratingAgeLimits = releaseData["ratingAgeLimits"] as? Int
        premiereWorld = releaseData["premiereWorld"] as? String
        slogan = releaseData["slogan"] as? String
        description = releaseData["description"] as? String
        countries = countriesData
        genres = genresData
    }
    
    static func getReleases(from responseData: [String: Any]) -> [FilmForRelease] {
        guard let releasesData = responseData["releases"] as? [[String: Any]] else { return [] }
        var releases: [FilmForRelease] = []
        for releaseData in releasesData {
            let countries: [Country] = Country.getCountries(from: releaseData)
            let genres: [Genre] = Genre.getGenres(from: releaseData)
            let movie = FilmForRelease(releaseData: releaseData, countriesData: countries, genresData: genres)
            releases.append(movie)
        }
        return releases
    }
}

struct Genre: Decodable  {
    let genre: String?
    
    init(genreData: [String: Any]) {
        genre = genreData["genre"] as? String
    }
    
    static func getGenres(from movieData: [String: Any]) -> [Genre] {
        guard let genresData = movieData["genres"] as? [[String: Any]] else { return [] }
        var genres: [Genre] = []
        for genreData in genresData {
            let genre = Genre(genreData: genreData)
            genres.append(genre)
        }
        return genres
    }
    
    static func getGenresString(from genres: [Genre]) -> String {
        var genresString = ""
        for (index, genre) in genres.enumerated() {
            if let genre = genre.genre {
                if index == (genres.count - 1) {
                    genresString += genre
                } else {
                    genresString += "\(genre), "
                }
            }
        }
        return genresString
    }
}

struct Country: Decodable {
    let country: String?
    
    init(countryData: [String: Any]) {
        country = countryData["country"] as? String
    }
    
    static func getCountries(from movieData: [String: Any]) -> [Country] {
        guard let countriesData = movieData["countries"] as? [[String: Any]] else { return [] }
        var countries: [Country] = []
        for countryData in countriesData {
            let country = Country(countryData: countryData)
            countries.append(country)
        }
        return countries
    }
    
    static func getCountriesString(from countries: [Country]) -> String {
        var countryList = ""
        for (index, country) in countries.enumerated() {
            if let country = country.country {
                if index == (countries.count - 1) {
                    countryList += country
                } else {
                    countryList += "\(country), "
                }
            }
        }
        return countryList
    }
}


