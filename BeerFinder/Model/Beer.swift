//
//  Beer.swift
//  BeerFinder
//
//  Created by Sasha Belov on 31.07.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation

struct Beer: Codable {
    let id: Int
    let name: String
    let beerType: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case beerType = "beer_type"
        case description
    }
}
