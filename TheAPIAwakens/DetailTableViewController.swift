//
//  DetailTableViewController.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/29/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


class DetailTableViewController: UITableViewController {
    
// MARK: Properties
    var selectedType: StarWarsTypes?
    var character: Character?
    var starship: Starship?
    var vehicle: Vehicle?
    
    var planets = [Planet]()
    var vehicles = [Vehicle]()
    var starships = [Starship]()
    
    weak var observer: NSObjectProtocol?
    
// MARK: Outlets
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var makeOrBdayTitle: UILabel!
    @IBOutlet weak var makeOrBdayLabel: UILabel!
    
    @IBOutlet weak var costOrHomeTitle: UILabel!
    @IBOutlet weak var costOrHomeLabel: UILabel!
    
    @IBOutlet weak var lengthOrHeightTitle: UILabel!
    @IBOutlet weak var lengthOrHeightLabel: UILabel!
    
    @IBOutlet weak var classOrEyesTitle: UILabel!
    @IBOutlet weak var classOrEyesLabel: UILabel!
    
    @IBOutlet weak var crewOrHairTitle: UILabel!
    @IBOutlet weak var crewOrHairLabel: UILabel!
    
    @IBOutlet weak var vehiclesLabel: UILabel!
    @IBOutlet weak var starshipsLabel: UILabel!
    
    
    @IBOutlet weak var titleCell: UITableViewCell!
    
    // Segmented controllers
    @IBOutlet weak var currencySegmentedController: UISegmentedControl!
    @IBOutlet weak var measurementSegmentedController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabels()
        setUpSegmentedControllers()
        removeSeparator()
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotifications().pickerDidChange, object: nil, queue: nil){ notification in
            guard let selectedType = self.selectedType else { return }

            self.displayData(from: notification, with: selectedType)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let observer = self.observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let selectedType = selectedType else { return 0 }
        if selectedType != .characters && indexPath.row >= 6 {
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    
// MARK: Methods
    func removeSeparator() {
        self.titleCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        self.titleCell.directionalLayoutMargins = .zero
    }
    
    func setUpSegmentedControllers() {
        let segmentedControllers = [currencySegmentedController, measurementSegmentedController]
        
        for segmentedController in segmentedControllers {
            guard let segmentedController = segmentedController else { return }
            
            segmentedController.tintColor = UIColor.clear
            segmentedController.backgroundColor = UIColor.clear
            let selectedColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
            let normalColor = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#626567")]
            segmentedController.setTitleTextAttributes(normalColor, for: .normal)
            segmentedController.setTitleTextAttributes(selectedColor, for: .selected)
        }
        
        guard let selectedType = self.selectedType else { return }
        if selectedType == .characters { self.currencySegmentedController.isHidden = true }
    }
    
    func setTitleLabels() {
        guard let selectedType = self.selectedType else { return }
        switch selectedType {
        case .characters:
            self.makeOrBdayTitle.text = "Born"
            self.costOrHomeTitle.text = "Home"
            self.lengthOrHeightTitle.text = "Height"
            self.classOrEyesTitle.text = "Eyes"
            self.crewOrHairTitle.text = "Hair"
        default: return
        }
    }
    
    func displayData(from notification: Notification, with selectedType: StarWarsTypes ) {
        switch selectedType {
            case .characters:
                let contents = notification.object as! Character
                self.character = contents
                self.nameLabel.text = contents.name
                self.makeOrBdayLabel.text = contents.birthYear
                self.lengthOrHeightLabel.text = contents.height
                self.classOrEyesLabel.text = contents.eyeColor
                self.crewOrHairLabel.text = contents.hairColor
                
                self.costOrHomeLabel.text = self.getPlanet(withURL: contents.homeworld)
                
                if measurementSegmentedController.selectedSegmentIndex == 0 {
                    self.lengthOrHeightLabel.text = ConversionMethod().feetAndInches(from: contents.height)
                } else {
                    self.lengthOrHeightLabel.text = "\(contents.height)cm"
                }
                
                self.vehiclesLabel.text = self.getVehicles(withURLs: contents.vehicles)
                self.starshipsLabel.text = self.getStarships(withURLs: contents.starships)
            case .starships:
                let contents = notification.object as! Starship
                self.starship = contents
                self.nameLabel.text = contents.name
                self.makeOrBdayLabel.text = contents.manufacturer
                self.classOrEyesLabel.text = contents.starshipClass
                self.crewOrHairLabel.text = ConversionMethod().addCommas(to: contents.crew)
                
                if measurementSegmentedController.selectedSegmentIndex == 0 {
                    self.lengthOrHeightLabel.text = ConversionMethod().feet(from: contents.length)
                } else {
                    self.lengthOrHeightLabel.text = "\(ConversionMethod().addCommas(to: contents.length))m"
                }
                
                if currencySegmentedController.selectedSegmentIndex == 0 {
                    self.costOrHomeLabel.text = ConversionMethod().dollar(from: contents.costInCredits)
                } else {
                    self.costOrHomeLabel.text = ConversionMethod().addCommas(to: contents.costInCredits)
                }
            case .vehicles:
                let contents = notification.object as! Vehicle
                self.vehicle = contents
                self.nameLabel.text = contents.name
                self.makeOrBdayLabel.text = contents.manufacturer
                self.classOrEyesLabel.text = contents.vehicleClass
                self.crewOrHairLabel.text = ConversionMethod().addCommas(to: contents.crew)
                
                if measurementSegmentedController.selectedSegmentIndex == 0 {
                    self.lengthOrHeightLabel.text = ConversionMethod().feet(from: contents.length)
                } else {
                    self.lengthOrHeightLabel.text = "\(ConversionMethod().addCommas(to: contents.length))m"
                }
                
                if currencySegmentedController.selectedSegmentIndex == 0 {
                    self.costOrHomeLabel.text = ConversionMethod().dollar(from: contents.costInCredits)
                } else {
                    self.costOrHomeLabel.text = ConversionMethod().addCommas(to: contents.costInCredits)
                }
            default: return
        }
    }
    
    
    func getPlanet(withURL url: String ) -> String {
        let filteredArray = self.planets.filter({ planet -> Bool in
            planet.url.lowercased().contains(url)
        })
        
        if filteredArray.count == 0 {
            return "unknown"
        }
        
        return filteredArray[0].name
    }
    
    // Get characters associated vehicles/starships
    func getVehicles(withURLs urls: [String]) -> String {
        var filteredArray = [String]()
        
        for url in urls {
            let newArray = self.vehicles.filter({ vehicle -> Bool in
                vehicle.url.lowercased().contains(url)
            })
            if !newArray.isEmpty {
                filteredArray.append(newArray[0].name)
            }
        }
        
        let vehiclesString: String = self.display(arrayOfStrings: filteredArray)
        
        return vehiclesString
    }
    func getStarships(withURLs urls: [String]) -> String {
        var filteredArray = [String]()
        
        for url in urls {
            let newArray = self.starships.filter({ starship -> Bool in
                starship.url.lowercased().contains(url)
            })
            if !newArray.isEmpty {
                filteredArray.append(newArray[0].name)
            }
        }
        
        let starshipString: String = self.display(arrayOfStrings: filteredArray)
        
        return starshipString
    }
    
    // Create string from array of objects
    func display(arrayOfStrings: [String]) -> String{
        if arrayOfStrings.isEmpty {
            return "unknown"
        }
        
        var displayString = ""
        
        for num in stride(from: 0, to: arrayOfStrings.count, by: 1) {
            if num == 0 {
                displayString = displayString + arrayOfStrings[num]
            } else {
                displayString = displayString + "\n\(arrayOfStrings[num])"
            }
        }
        return displayString
    }
    
    
    
// MARK: Actions
    
    @IBAction func currencySegmentChanged(_ sender: Any) {
        guard let selectedType = self.selectedType else { return }
        let currentIndex = currencySegmentedController.selectedSegmentIndex
        switch currentIndex {
            case 0:
                switch selectedType {
                    case .starships:
                        guard let starship = self.starship else { return }
                        let dollars = ConversionMethod().dollar(from: starship.costInCredits)
                        self.costOrHomeLabel.text = dollars
                    case .vehicles:
                        guard let vehicle = self.vehicle else { return }
                        let dollars = ConversionMethod().dollar(from: vehicle.costInCredits)
                        self.costOrHomeLabel.text = dollars
                    default: return
                }
            case 1:
                switch selectedType {
                    case .starships:
                        guard let starship = self.starship else { return }
                        let galacticCredits = ConversionMethod().addCommas(to: starship.costInCredits)
                        self.costOrHomeLabel.text = galacticCredits
                    case .vehicles:
                        guard let vehicle = self.vehicle else { return }
                        let galacticCredits = ConversionMethod().addCommas(to: vehicle.costInCredits)
                        self.costOrHomeLabel.text = galacticCredits
                    default: return
                }
            default: return
        }
    }
    
    @IBAction func measurementSegmentChanged(_ sender: Any) {
        guard let selectedType = self.selectedType else { return }
        let currentIndex = measurementSegmentedController.selectedSegmentIndex
        switch currentIndex {
            case 0:
                switch selectedType {
                    case .starships:
                        guard let starship = self.starship else { return }
                        let feet = ConversionMethod().feet(from: starship.length)
                        self.lengthOrHeightLabel.text = feet
                    case .vehicles:
                        guard let vehicle = self.vehicle else { return }
                        let feet = ConversionMethod().feet(from: vehicle.length)
                        self.lengthOrHeightLabel.text = feet
                    case .characters:
                        guard let character = self.character else { return }
                        let height = ConversionMethod().feetAndInches(from: character.height)
                        self.lengthOrHeightLabel.text = height
                    default: return
            }
            case 1:
                switch selectedType {
                    case .characters:
                        guard let character = self.character else { return }
                        self.lengthOrHeightLabel.text = "\((character.height))cm"
                    case .starships:
                        guard let starship = self.starship else { return }
                        self.lengthOrHeightLabel.text = "\(ConversionMethod().addCommas(to: starship.length))m"
                    case .vehicles:
                        guard let vehicle = self.vehicle else { return }
                        self.lengthOrHeightLabel.text = "\(ConversionMethod().addCommas(to: vehicle.length))m"
                    default: return
            }
            default: return
        }
    }
    
}
