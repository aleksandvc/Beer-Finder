//
//  AllBeersViewController.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit
import Bondage

protocol BeersNetworkingProtocol {
    var beers: BindableArray<Beer> { get set }
    func getAllBeers(presenter: UIViewController, completion: (()->())?)
}

class AllBeersViewController: UIViewController {
    
    @IBOutlet private weak var beersTableView: UITableView!
    @IBOutlet weak var addBeerButton: UIButton!
    
    var viewModel: BeersNetworkingProtocol = AllBeersViewModel()
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = getActivityIndicator()
        addBeerButton.layer.cornerRadius = 5
        
        viewModel.beers.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.beersTableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        
        viewModel.getAllBeers(presenter: self) {
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //Showing small loading circle while the request is executing
    private func getActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        return indicator
    }
    
    func presentMoreInfoAboutBeerScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let moreInfoVC = storyboard.instantiateViewController(withIdentifier: "MoreInfoViewController") as? MoreInfoViewController else { return }
        moreInfoVC.viewModel = MoreInfoViewModel(id: id)
        DispatchQueue.main.async {
            self.present(moreInfoVC, animated: true, completion: nil)
        }
    }
    
    func presentUploadBeerScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let moreInfoVC = storyboard.instantiateViewController(withIdentifier: "UploadNewBeerViewController") as? UploadNewBeerViewController else { return }
        moreInfoVC.viewModel = UploadBeerViewModel()
        DispatchQueue.main.async {
            self.present(moreInfoVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapAddBeerButton(_ sender: Any) {
        presentUploadBeerScreen()
    }
}

extension AllBeersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.beers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.beers.value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.beers.value[indexPath.row].id
        presentMoreInfoAboutBeerScreen(with: id)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
}

extension AllBeersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
}
