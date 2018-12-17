//
//  HomeViewController.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/29/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import UIKit
import Spring

class HomeViewController: UIViewController {

// MARK: Properties
    var selectedType: StarWarsTypes?
    
    var characters = [Character]()
    var starships = [Starship]()
    var vehicles = [Vehicle]()
    var planets = [Planet]()
    
    var packagesReceived = 0
    
// MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingDataLbl: UILabel!
    @IBOutlet weak var characterBtn: SpringButton!
    @IBOutlet weak var vehicleBtn: SpringButton!
    @IBOutlet weak var starshipBtn: SpringButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        JSONDownloader().downloadJSON(for: .characters)
        JSONDownloader().downloadJSON(for: .starships)
        JSONDownloader().downloadJSON(for: .vehicles)
        JSONDownloader().downloadJSON(for: .planets)
        
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonCharacterRequestDidComplete, object: nil, queue: nil){ notification in
            let contents = notification.object as! [Character]
            self.characters.append(contentsOf: contents)
            self.packagesReceived += 1
            self.checkDownloads()
            print("Characters did complete with \(self.characters.count)")
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonStarshipRequestDidComplete, object: nil, queue: nil){ notification in
            if let contents = notification.object as? [Starship] {
                self.starships.append(contentsOf: contents)
                self.packagesReceived += 1
                self.checkDownloads()
                print("Starships did complete with \(self.starships.count)")
                return
            } else {
                guard let errorMessage = notification.object as? String else { return }
                AlertUser().generalAlert(title: "Starships Error", message: errorMessage, vc: self)
            }
            
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonVehicleRequestDidComplete, object: nil, queue: nil){ notification in
            let contents = notification.object as! [Vehicle]
            self.vehicles.append(contentsOf: contents)
            self.packagesReceived += 1
            self.checkDownloads()
            print("Vehicles did complete with \(self.vehicles.count)")
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonPlanetsRequestDidComplete, object: nil, queue: nil){ notification in
            let contents = notification.object as! [Planet]
            self.planets.append(contentsOf: contents)
            self.packagesReceived += 1
            self.checkDownloads()
            print("Planets did complete with \(self.planets.count)")
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().jsonError, object: nil, queue: nil) { notification in
            if let jsonError = notification.object as? JSONError {
                AlertUser().generalAlert(title: "Error \(jsonError.type.naveTitle)", message: jsonError.errorMessage, vc: self)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotifications().networkError, object: nil, queue: nil) { notification in
            if let networkError = notification.object as? String {
                AlertUser().generalAlert(title: "Network Error", message: networkError, vc: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard let destinationNavigationController = segue.destination as? UINavigationController,
                let targetController = destinationNavigationController.topViewController as? DetailViewController,
                let selectedType = self.selectedType else { return }
            
            targetController.selectedType = selectedType
            targetController.characters = self.characters
            targetController.starships = self.starships
            targetController.vehicles = self.vehicles
            targetController.planets = self.planets
        }
    }
    
// MARK: Methods
    func checkDownloads() {
//        let arrayOfObjects: [[Any]] = [characters, starships, vehicles, planets]
//        for array in arrayOfObjects {
//            if array.count == 0 {
//                return
//            }
//        }
        if self.packagesReceived != 4 {
            return
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingDataLbl.isHidden = true
            self.enableButtons()
        }
    }
    
    func enableButtons() {
        let arrayOfBtns: [SpringButton] = [characterBtn, starshipBtn, vehicleBtn]
        for button in arrayOfBtns {
            button.isEnabled = true
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
            button.animation = "zoomIn"
            button.duration = 1.0
            button.velocity = 1.0
            button.animate()
        }
    }
    

    
// MARK: Actions
    @IBAction func categoryPressed(_ sender: SpringButton) {
        switch sender.restorationIdentifier {
            case "CharactersBtn":
                self.selectedType = .characters
            case "VehiclesBtn":
                self.selectedType = .vehicles
            case "StarshipsBtn":
                self.selectedType = .starships
            default: return
        }
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
        
    }
    
}

