//
//  AllBeersViewModel.swift
//  BeerFinder
//
//  Created by Sasha Belov on 1.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AllBeersViewModel {
    
    let networkManager = NetworkManager()
    
    var limitOfNextLoadedBeers = 4
    var beers: [NSManagedObject] = []
    var shownBeersArray:[NSManagedObject] = []
    
    func getAllBeers(presenter: UIViewController, completion: ((Bool) -> ())?) {
        let beersCount = UserDefaults.standard.value(forKey: "beersCount") as? Int ?? 0
        networkManager.getAllBeers(presenter: presenter, completion: { [weak self] beersFromServer, areDownloaded in
            if let strongSelf = self, let beersFromApi = beersFromServer {
                if beersCount != beersFromApi.count {
                    strongSelf.clearStorage()
                    for beer in beersFromApi {
                        DispatchQueue.main.async {
                            strongSelf.saveToCoreData(beer: beer)
                        }
                    }
                    UserDefaults.standard.set(beersFromApi.count, forKey: "beersCount")
                } else {
                    DispatchQueue.main.async {
                        strongSelf.getBeersFromCoreData(completion: {})
                    }
                }
            }
            completion?(areDownloaded)
        })
    }
    
    //MARK: Private methods
    private func clearStorage() {
        clearAllEntitiesFromCoreData()
        beers = []
        shownBeersArray = []
    }
    
    private func clearAllEntitiesFromCoreData() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BeerObject")
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try managedContext.execute(deleteRequest)
            } catch let error as NSError {
                 print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func saveToCoreData(beer: Beer) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "BeerObject",
                                       in: managedContext)!
        
        let beerObject = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        
        beerObject.setValue(beer.name, forKeyPath: "name")
        beerObject.setValue(beer.id, forKey: "id")
        beerObject.setValue(beer.beerType, forKey: "beerType")
        beerObject.setValue(beer.description, forKey: "beerDescription")
        
        do {
            try managedContext.save()
            beers.append(beerObject)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getBeersFromCoreData(completion: ()->()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BeerObject")
        
        do {
            beers = try managedContext.fetch(fetchRequest)
            print("---------------\(beers.count)")
            completion()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


