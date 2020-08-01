//
//  UploadBeerViewModel.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class UploadBeerViewModel: NSObject, UploadBeerNetworkingProtocol {
    
    let networkManager = NetworkManager()
    
    func uploadBeer(presenter: UIViewController, beer: Beer) {
        networkManager.uploadNewBeer(presenter: presenter, beer: beer)
    }
}
