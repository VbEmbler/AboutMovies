//
//  releasesTableViewController.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit

class ReleasesTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var releases = DigitalRelease(page: nil, total: nil, releases: [])
    var currentYear = ""
    var currentMonth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        let page = 1
        let moviesInPage = 10
        let date = Date()
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        
        currentYear = yearFormatter.string(from: date)
        currentMonth = monthFormatter.string(from: date).uppercased()
        tabBarController?.title = "\(currentYear) \(currentMonth)"
        
        NetworkManager.shared.getReleases(
            year: currentYear, month: currentMonth,
            page: page, userCompletionHandler: { (releases, error) in
                if let releases = releases {
                    self.releases = releases
                    if let moviesCount = releases.total {
                        //Сделал такой вызов функции для того, чтоб получить полный список фильмов
                        //Api Не хочет отдавать весь список, только по страницам отдает
                        let pagesCount = moviesCount / moviesInPage
                        for page in 2...pagesCount + 1 {
                            NetworkManager.shared.getReleases(
                                year: self.currentYear, month: self.currentMonth,
                                page: page, userCompletionHandler: { (releases, error) in
                                
                                    if let releases = releases {
                                    self.releases.releases.append(contentsOf: releases.releases)
                                }
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                }
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let total = releases.releases.count 
        return total
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "releaseCell", for: indexPath)
        
        if let name = releases.releases[indexPath.row].nameRu {
            cell.textLabel?.text = name
        }
        if let genre = releases.releases[indexPath.row].genres.first {
            cell.detailTextLabel?.text = genre.genre
        }
        
        guard let stringURL = releases.releases[indexPath.row].posterUrlPreview else { return cell }
        guard let imageURL = URL(string: stringURL) else { return cell }
        guard let imageData = try? Data(contentsOf: imageURL) else { return cell }
        
        
        cell.imageView?.image = UIImage(data: imageData)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieDetailsVC = segue.destination as! MovieDetailsViewController 
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        movieDetailsVC.movieId = releases.releases[indexPath.row].filmId
    }
    
}
