//
//  DatePicker.swift
//  AmusementParkPassGeneratorPart2
//
//  Created by Brandon Mahoney on 11/23/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


class OptionPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK: Properties
    var selectedType: StarWarsTypes?
    var characters = [Character]()
    var starships = [Starship]()
    var vehicles = [Vehicle]()
    
    
    init(selectedType: StarWarsTypes, arrayOfOptions: [Any]) {
        super.init(frame: CGRect.zero)
        self.selectedType = selectedType
        
        switch selectedType {
            case .characters: self.characters = arrayOfOptions as! [Character]
            case .starships: self.starships = arrayOfOptions as! [Starship]
            case .vehicles: self.vehicles = arrayOfOptions as! [Vehicle]
            default: return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectedType = self.selectedType else { return 0 }
        switch selectedType {
            case .characters: return self.characters.count
            case .starships: return self.starships.count
            case .vehicles: return self.vehicles.count
            default: return 0
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectedType = self.selectedType else { return "" }
        switch selectedType {
            case .characters: return self.characters[row].name
            case .starships: return self.starships[row].name
            case .vehicles: return self.vehicles[row].name
            default: return ""
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedType = self.selectedType else { return }
        switch selectedType {
            case .characters: NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: self.characters[row])
            case .starships: NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: self.starships[row])
            case .vehicles: NotificationCenter.default.post(name: NSNotifications().pickerDidChange, object: self.vehicles[row])
            default: return
        }
    }
}
