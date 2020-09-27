//
//  MovieDetailsViewController.swift
//  AboutMovies
//
//  Created by Vladimir on 22/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit
import AVKit


class MovieDetailsViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieDetailsLabel: UILabel!
    @IBOutlet weak var movieSloganLabel: UILabel!
    
    //MARK: - Public Properties
    var movieId: Int!
    var movieURL = ""
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getMovieBy(movieId) { movie, error in
            self.setMovieDetails(for: movie?.data)
            self.setupMovieImageView(from: movie?.data?.posterUrl)
        }
    }
    
    //MARK: - Private Methods
    private func setupMovieImageView(from url: String?) {
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: url) else { return }
            DispatchQueue.main.async {
                self.moviePosterImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setMovieDetails(for movie: Film?) {
        var countries = ""
        var genres = ""
        if let countriesData = movie?.countries {
            countries = Country.getCountriesString(from: countriesData)
        }
        if let genresData = movie?.genres {
            genres = Genre.getGenresString(from: genresData)
        }
        
        DispatchQueue.main.async {
            self.movieSloganLabel.text = movie?.slogan ?? ""
            self.movieDescriptionLabel.text = movie?.description ?? ""
            self.movieDetailsLabel.text = """
            \(movie?.nameRu ?? "")
            \(movie?.year ?? "")
            \(countries)
            Premier: \(movie?.premiereWorld ?? "")
            \(genres)
            Raiting Age: \(movie?.ratingAgeLimits ?? 0)
            \(movie?.filmLength ?? "")
            """
        }
    }
}
