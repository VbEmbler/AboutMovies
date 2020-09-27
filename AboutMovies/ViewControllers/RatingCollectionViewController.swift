//
//  RatingCollectionViewController.swift
//  AboutMovies
//
//  Created by Vladimir on 24/09/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit


class RatingCollectionViewController: UICollectionViewController {
    
    //MARK: - Private Properties
    private let raitings = Ratings.allCases
    private var topId = 0
    
    //MARK: - Override Methods
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.title = "Tops of popular movies"
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return raitings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: indexPath) as! RatingCollectionViewCell
        
        let ratings = raitings[indexPath.item]
        
        cell.ratingCellLabel.text = ratings.rawValue
        cell.ratingCellImageView.image = UIImage(named: ratings.rawValue)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("printDidSelect")
    }
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let userAction = raitings[indexPath.item]
        switch userAction {
        case .topBestFilms:
            topId = 1
        case .topMelodrams:
            topId = 2
        case .topComedies:
            topId = 3
        case .topFantastic:
            topId = 4
        case .topActions:
            topId = 5
        case .topCartoons:
            topId = 6
        }
        print("Should:")
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let moviesTVC = segue.destination as! MovieListTableViewController
        moviesTVC.isTop = true
        moviesTVC.topId = topId
        print("prepeare")
    }
}

//MARK: - Enums
enum Ratings: String, CaseIterable {
    case topBestFilms = "Top 250 best films"
    case topMelodrams = "Top 30 melodrams"
    case topComedies = "Top 30 comedies"
    case topFantastic = "Top 30 fantastic films"
    case topActions = "Top 30 actions"
    case topCartoons = "Top 30 cartoons"
}

//MARK: - Extensions
extension RatingCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 30)
    }
}
