//
//  ViewController.swift
//  BeerFinder
//
//  Created by Sasha Belov on 31.07.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just for test
//        let beer = Beer(id: 100, name: "Mlado pivo", beerType: "BG", description: "Hubava birichka")
        networkManager.getBeer(presenter: self, id: 89, completion: nil)
    }


}

