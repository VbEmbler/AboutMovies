//
//  releasesTableViewController.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Public Properties
    var isTop = false
    var topId = 0
    
    //MARK: - Private Properties
    private var releases = DigitalRelease(responceData: [:], releasesData: [])
    private var topMovies = TopMovie(responseData: [:], filmsData: [])
    private var currentYear = ""
    private var currentMonth = ""

    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        let date = Date()
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        
        currentYear = yearFormatter.string(from: date)
        currentMonth = monthFormatter.string(from: date).uppercased()

        
        if !isTop {
            loadReleasesList()
        } else {
            loadTopMoviesList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.title = "\(currentYear) \(currentMonth)"
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTop ? topMovies.films.count : releases.releases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        if isTop {
            cell.configure(with: topMovies.films[indexPath.row])
        } else {
            cell.configure(with: releases.releases[indexPath.row])
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetailsVC = segue.destination as! MovieDetailsViewController 
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if isTop {
            movieDetailsVC.movieId = topMovies.films[indexPath.row].filmId
        } else {
            movieDetailsVC.movieId = releases.releases[indexPath.row].filmId
        }
    }
    
    //MARK: - Private Methods
    private func loadReleasesList() {
        let moviesInPage = 10
        NetworkManager.shared.getReleases(
            year: currentYear,
            month: currentMonth) { releases, error in
                if let releases = releases {
                    self.releases = releases
                    if let moviesCount = releases.total {
                        //Сделал такой вызов функции для того, чтоб получить полный список фильмов
                        //Api Не хочет отдавать весь список, только по страницам отдает
                        let pagesCount = moviesCount / moviesInPage
                        for page in 2...pagesCount + 1 {
                            NetworkManager.shared.getReleases(
                                year: self.currentYear, month: self.currentMonth,
                                page: page) { releases, error in
                                    if let releases = releases {
                                        self.releases.releases.append(contentsOf: releases.releases)
                                    }
                                    DispatchQueue.main.async {
                                        self.activityIndicator.stopAnimating()
                                        self.tableView.reloadData()
                                    }
                            }
                        }
                    }
                }
        }
    }
    
    private func loadTopMoviesList() {
        NetworkManager.shared.getTopMovies(topId: topId) { (topMovies, error) in
            if let topMovies = topMovies {
                self.topMovies = topMovies
                if let pageCount = topMovies.pagesCount, pageCount > 0 {
                    for page in 2...pageCount {
                        NetworkManager.shared.getTopMovies(
                            topId: self.topId,
                            pageId: page) { (topMovies, error) in
                                if let topMovies = topMovies {
                                    self.topMovies.films.append(contentsOf: topMovies.films)
                                }
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    self.tableView.reloadData()
                                }
                        }
                    }
                }
            }
        }
    }
}
