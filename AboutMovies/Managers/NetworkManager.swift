//
//  NetworkManager.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//
import Foundation
import Alamofire

class NetworkManager {
    
    //MARK: - Public Properties
    static let shared = NetworkManager()
    
    //MARK: - Private Properties
    private let headers: HTTPHeaders = [
        "X-API-KEY": "7c49f2b3-8625-4b70-88ed-edbfaf317157",
        "Accept": "application/json"
    ]
    
    //MARK: - Initialiers
    private init() {}
    
    //MARK: Public Methods
    func getMovieBy(_ id: Int, completionHandler: @escaping (Movie?, Error?) -> Void) {
        
        AF.request("https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(id))",
            headers: headers)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let movie = Movie.getMovie(from: value)
                    completionHandler(movie, nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    func getTopMovies(topId: Int, pageId: Int = 1, completeonHandler: @escaping (TopMovie?, Error?) -> Void) {
        AF.request("https://kinopoiskapiunofficial.tech/api/v2.1/films/top?page=\(pageId)&listId=\(topId)",
            headers: headers)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let topMovies = TopMovie.getTopMovies(from: value)
                    completeonHandler(topMovies, nil)
                case .failure(let error):
                    completeonHandler(nil, error)
                }
        }
    }
    
    func getReleases(year: String = "2020", month: String = "SEPTEMBER", page: Int = 1, completeonHandler: @escaping (DigitalRelease?, Error?) -> Void) {
        AF.request("https://kinopoiskapiunofficial.tech/api/v2.1/films/releases?year=\(year)&month=\(month)&page=\(page)",
            headers: headers)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let digitalRelease = DigitalRelease.getDigitalRelease(from: value)
                    completeonHandler(digitalRelease, nil)
                case .failure(let error):
                    completeonHandler(nil, error)
                }
        }
    }
}

