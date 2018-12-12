//
//  DetailViewController.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/29/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import Spring

class DetailViewController: UIViewController {
    
// MARK: Properties
    var selectedType: StarWarsTypes?
    var characters = [Character]()
    var starships = [Starship]()
    var vehicles = [Vehicle]()
    var planets = [Planet]()
    
    var optionPicker: OptionPicker?
    
// MARK: Outlets
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var sizesView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    // PickerView Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerWindow: UIView!
    @IBOutlet weak var sizeViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewToggleBtn: UIButton!
    @IBOutlet var swipeUpRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownRecognizer: UISwipeGestureRecognizer!
    
    
// MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedType?.naveTitle
        self.setUpPickers()
        self.findSmallestAndShortest()
        self.setDropshadow()
        self.swipeUpRecognizer.direction = .up
        self.swipeDownRecognizer.direction = .down
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pickerViewAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTableViewSegue" {
            let destinationTableVC = segue.destination as! DetailTableViewController
            print("selectedType in DetailVC prepareForSegue: \(String(describing: self.selectedType))")
            destinationTableVC.selectedType = self.selectedType
            destinationTableVC.planets = self.planets
            destinationTableVC.vehicles = self.vehicles
            destinationTableVC.starships = self.starships
        }
    }
    
// MARK: Methods
    func setUpPickers() {
        // Set up companyPicker
        guard let selectedType = self.selectedType else { return }
        print("selectedType setUpPickers(): \(selectedType)")
        switch selectedType {
            case .characters: self.optionPicker =  OptionPicker(selectedType: self.selectedType!, arrayOfOptions: self.characters)
                let currentSelected = optionPicker!.characters[pickerView.selectedRow(inComponent: 0)]
                NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: currentSelected)
            case .starships: self.optionPicker =  OptionPicker(selectedType: self.selectedType!, arrayOfOptions: self.starships)
                let currentSelected = optionPicker!.starships[pickerView.selectedRow(inComponent: 0)]
                NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: currentSelected)
            case .vehicles: self.optionPicker = OptionPicker(selectedType: self.selectedType!, arrayOfOptions: self.vehicles)
                let currentSelected = optionPicker!.vehicles[pickerView.selectedRow(inComponent: 0)]
                NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: currentSelected)
            default: return
        }
        pickerView.dataSource = self.optionPicker
        pickerView.delegate = self.optionPicker
        
    }
    
    func setDropshadow() {
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.sizesView.layer.shadowColor = UIColor.black.cgColor
        self.sizesView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.sizesView.layer.shadowRadius = 4.0
        self.sizesView.layer.shadowOpacity = 1.0
        self.sizesView.layer.masksToBounds = false
    }
    
    func findSmallestAndShortest() {
        guard let selectedType = self.selectedType else { return }
        switch selectedType {
            case .characters:
                let newArray = self.characters.filter({ character -> Bool in
                    character.height.lowercased() != "unknown"
                })
                for character in newArray {
                    character.height = character.height.replacingOccurrences(of: ",", with: "")
                }
                let sorted = newArray.sorted {$0.height.localizedStandardCompare($1.height) == .orderedAscending}
                self.smallestLabel.text = sorted.first?.name
                self.largestLabel.text = sorted.last?.name
            case .starships:
                let newArray = self.starships.filter({ starship -> Bool in
                    starship.length.lowercased() != "unknown"
                })
                for starship in newArray {
                    starship.length = starship.length.replacingOccurrences(of: ",", with: "")
                }
                let sorted = newArray.sorted {$0.length.localizedStandardCompare($1.length) == .orderedAscending}
//                newArray.sort {
//                    ($0.length as NSString).compare($1.length, options: .numeric) == .orderedAscending
//                }
                self.smallestLabel.text = sorted.first?.name
                self.largestLabel.text = sorted.last?.name
            case .vehicles:
                let newArray = self.vehicles.filter({ vehicle -> Bool in
                    vehicle.length.lowercased() != "unknown"
                })
                for vehicle in newArray {
                    vehicle.length = vehicle.length.replacingOccurrences(of: ",", with: "")
                }
                let sorted = newArray.sorted {$0.length.localizedStandardCompare($1.length) == .orderedAscending}
                self.smallestLabel.text = sorted.first?.name
                self.largestLabel.text = sorted.last?.name
            default: return
        }
    }
    
    // Some measurements returned from API include commas but most do not. Removing them in order to allow accurate sorting for defining smallest/largest.
    func removeCommas() {
        
    }
    
    func pickerViewAnimation() {
        let extendedConstant: CGFloat = pickerView.frame.height + pickerViewToggleBtn.frame.height
        
        if self.sizeViewTopConstraint.constant != extendedConstant {
            self.sizeViewTopConstraint.constant = extendedConstant
        }else{
            self.sizeViewTopConstraint.constant = 15
        }
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.view.layoutIfNeeded()
        }, completion: nil
        )
    }
    
    
    
    
// MARK: Actions
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func togglePickerView(_ sender: Any) {
        self.pickerViewAnimation()
    }
    
}

