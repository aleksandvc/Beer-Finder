//
//  OneBeerViewController.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

protocol MoreInfoNetworkingProtocol {
    func getBeer(presenter: UIViewController, completion: ((Beer?)->())?)
}

class MoreInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: MoreInfoNetworkingProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 5
        //Could get info directly from the previous screen, but need to use the api
        viewModel?.getBeer(presenter: self, completion: { [weak self] beer in
            guard let strongSelf = self, let beer = beer else { return }
            DispatchQueue.main.async {
                strongSelf.nameLabel.text = "Name: \(beer.name)"
                strongSelf.typeLabel.text = "Type: \(beer.beerType)"
                strongSelf.descriptionLabel.text = "Description: \(beer.description)"
            }
        })
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
