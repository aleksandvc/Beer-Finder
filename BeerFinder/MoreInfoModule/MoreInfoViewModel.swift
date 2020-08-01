//
//  OneBeerViewModel.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class MoreInfoViewModel: NSObject, MoreInfoNetworkingProtocol {
    
    let networkManager = NetworkManager()
    var beerId: Int?
    
    init(id: Int) {
        super.init()
        beerId = id
    }
    
    func getBeer(presenter: UIViewController, completion: ((Beer?) -> ())?) {
        guard let id = beerId else { return }
        networkManager.getBeer(presenter: presenter, id: id, completion: completion)
    }
}
