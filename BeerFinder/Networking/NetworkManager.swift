//
//  NetworkManager.swift
//  BeerFinder
//
//  Created by Sasha Belov on 31.07.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    func getBeer(presenter: UIViewController,id: Int, completion: ((Beer?)->())?) {
        guard let url = URL(string: "\(AppEndPoints.getBeerURL)\(id)/") else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var beer: Beer?
            if let dataResponse = data {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    //Decode JSON Response Data
                    let model = try decoder.decode(Beer.self,
                                                   from: dataResponse)
                    beer = model
                    print(beer ?? "No such id")
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    presenter.present(alert, animated: false, completion: nil)
                }
            }
            
            completion?(beer)
        })
        
        task.resume()
    }
    
    func uploadNewBeer(presenter: UIViewController, beer: Beer, completion:@escaping  ()->()) {
        guard let url = URL(string: AppEndPoints.postNewBeerURL) else { return }
        
        var request  = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonBody = try JSONEncoder().encode(beer)
            
            request.httpBody = jsonBody
            print(jsonBody)
        } catch{
            print("some error")
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let dataResponse = data {
                let message = String(data: dataResponse, encoding: .utf8)
                print(message ?? "No message")
                completion()
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    presenter.present(alert, animated: false, completion: nil)
                }
            }
        })
        
        task.resume()
    }
    
    func getAllBeers(presenter: UIViewController, completion: (([Beer]?, Bool)->())?) {
        guard let url = URL(string: AppEndPoints.getAllBeersURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            var beersArray: [Beer]?
            if let dataResponse = data {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    //Decode JSON Response Data
                    let array = try decoder.decode([Beer].self,
                                                   from: dataResponse)
                    beersArray = array
                    completion?(beersArray, true)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    presenter.present(alert, animated: false, completion: nil)
                    completion?(nil, false)
                }
            }
        })
        
        task.resume()
    }
    
}
