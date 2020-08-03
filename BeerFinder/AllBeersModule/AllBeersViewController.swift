//
//  AllBeersViewController.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

class AllBeersViewController: UIViewController {
    
    @IBOutlet private weak var beersTableView: UITableView!
    @IBOutlet weak var addBeerButton: UIButton!
    
    var viewModel = AllBeersViewModel()
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = getActivityIndicator()
        addBeerButton.layer.cornerRadius = 5
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }

        //Will work offline, but for the first launch ever user should be connected to internet to download the records.
        getData()
    }
    
    private func prepareForPagination() {
        print("++++++++++++++++++++++++++++++++++++++++++++++++++\(viewModel.beers.count)")
        
        var index = 0
        if viewModel.beers.count > 0 {
            for _ in 0...viewModel.limitOfNextLoadedBeers - 1 {
                viewModel.shownBeersArray.append(viewModel.beers[index])
                index = index + 1
            }
            beersTableView.reloadData()
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
    
    func getData() {
        viewModel.getAllBeers(presenter: self) { areDownloaded in
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
                if areDownloaded {
                    self.prepareForPagination()
                } else {
                    self.viewModel.getBeersFromCoreData {
                        self.prepareForPagination()
                    }
                }
            }
        }
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
        moreInfoVC.delegate = self
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
        return viewModel.shownBeersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row) \(viewModel.shownBeersArray[indexPath.row].value(forKey: "name") as? String ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.shownBeersArray[indexPath.row].value(forKey: "id") as? Int ?? 0
        presentMoreInfoAboutBeerScreen(with: id)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.shownBeersArray.count - 1 {
            if indexPath.row == (viewModel.beers.count - 1) {
                return
            }
            //load more data
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        var index = viewModel.shownBeersArray.count
        for _ in 0..<viewModel.limitOfNextLoadedBeers {
            if viewModel.shownBeersArray.count == viewModel.beers.count {
               continue
            }
            viewModel.shownBeersArray.append(viewModel.beers[index])
            index = index + 1
            
        }
        DispatchQueue.main.async {
            self.beersTableView.reloadData()
        }
        
    }
}

extension AllBeersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
}


extension AllBeersViewController: ReloadTableViewDelegate {
    func reloadTableView(with beer: Beer) {
        DispatchQueue.main.async {
            self.getData()
        }
    }
}
