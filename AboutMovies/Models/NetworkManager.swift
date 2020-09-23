//
//  NetworkManager.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getReleases(year: String = "2020", month: String = "SEPTEMBER", page: Int = 1, userCompletionHandler: @escaping (DigitalRelease?, Error?) -> Void) {
        
        var releases = DigitalRelease(page: nil, total: nil, releases: [])
        
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/releases?year=\(year)&month=\(month)&page=\(page)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("7c49f2b3-8625-4b70-88ed-edbfaf317157", forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request, completionHandler:  { (data, response, error) in
            if let error = error {
                print(error)
                //print(error.localizedDescription)
                return
            }
            //             if let response = response {
            //                 print("!!!!!response \(response)")
            //             }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    releases = try jsonDecoder.decode(DigitalRelease.self, from: data)
                    userCompletionHandler(releases, nil)
                    //print(releases)
                } catch let error {
                    userCompletionHandler(nil, error)
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }
    
    func getMovieBy(id: Int) -> Film {
        var movie: Film!
        
        guard let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(id)?append_to_response=") else { return movie }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("7c49f2b3-8625-4b70-88ed-edbfaf317157", forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request)  { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            //             if let response = response {
            //                 print(response)
            //             }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    movie = try jsonDecoder.decode(Film.self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        return movie
    }
}
