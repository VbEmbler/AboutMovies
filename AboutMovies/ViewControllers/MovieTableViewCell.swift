//
//  MovieTableViewCell.swift
//  AboutMovies
//
//  Created by Vladimir on 26/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: - IB Outlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var nameRuLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    
    //MARK: - Public methods
    func configure(with filmData: Any) {
        if let film  = filmData as? Film {
            nameEnLabel.text = film.nameEn
            nameRuLabel.text = film.nameRu
            genresLabel.text = Genre.getGenresString(from: film.genres)
            let countries = Country.getCountriesString(from: film.countries)
            countriesLabel.text = countries + " " + (film.year ?? "")
            
            DispatchQueue.global().async {
                if let imageData = ImageManager.shared.fetchImage(
                    from: film.posterUrlPreview) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: imageData)
                    }
                }
            }
        } else if let release = filmData as? FilmForRelease {
            nameEnLabel.text = release.nameEn
            nameRuLabel.text = release.nameRu
            genresLabel.text = Genre.getGenresString(from: release.genres)// getGenres(from: release.genres)
            
            if let year = release.year {
                countriesLabel.text = ("\(Country.getCountriesString(from: release.countries)) \(year)")
            } else {
                countriesLabel.text = Country.getCountriesString(from: release.countries)
            }
            
            DispatchQueue.global().async {
                if let imageData = ImageManager.shared.fetchImage(
                    from: release.posterUrlPreview) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    

}
