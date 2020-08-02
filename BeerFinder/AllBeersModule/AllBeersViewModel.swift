//
//  AllBeersViewModel.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class AllBeersViewModel {
    
    let networkManager = NetworkManager()
    
    var limitOfShownBeers = 8
    var beers: [Beer] = []
    var shownBeersArray:[Beer] = []
    
    func getAllBeers(presenter: UIViewController, completion: (() -> ())?) {
        networkManager.getAllBeers(presenter: presenter, completion: { [weak self] beers in
            guard let strongSelf = self, let beers = beers else { return }
            for beer in beers {
                strongSelf.beers.append(beer)
            }
            completion?()
        })
    }
}


