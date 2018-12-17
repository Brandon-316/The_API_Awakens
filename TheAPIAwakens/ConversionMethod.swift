//
//  ConversionMethods.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 12/5/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation


class ConversionMethod {
    
    // Measurement conversions
    func feetAndInches(from centimeters: String) -> String {
        guard let centimetersDouble: Double = Double(centimeters) else { return centimeters }
        let metric = Measurement(value: centimetersDouble, unit: UnitLength.centimeters)
        let inches = metric.converted(to: UnitLength.inches)
        let feet = inches / 12.0
        
        let footInt = Int(feet.value)
        
        var remainderInches = inches.value.truncatingRemainder(dividingBy: 12.0)
        remainderInches = remainderInches.round(nearest: 0.5)
        
        if remainderInches == 0.0 || remainderInches.truncatingRemainder(dividingBy: 1.0) == 0 {
            return "\(footInt)' \(Int(remainderInches))\""
        }
        
        return "\(footInt)' \(remainderInches)\""
    }
    
    func feet(from meters: String) -> String {
        guard let metersDouble: Double = Double(meters) else { return meters }
        let metric = Measurement(value: metersDouble, unit: UnitLength.meters)
        let feet = metric.converted(to: UnitLength.feet)
        let feetDouble = feet.value.rounded()
        // Convert to Int to remove decimal point
        let feetInt = Int(feetDouble)
        let feetString = String(feetInt)
        let feetWithCommas = addCommas(to: feetString)
        
        return "\(feetWithCommas)ft"
    }
    
    
    // Currency conversion
    func dollar(from galactic: String) -> String {
        guard let galacticInt = Int(galactic) else { return galactic }
        let currentExchangeRate: Int = UserDefaults.standard.integer(forKey: "exchangeRate")
        let dollarInt = galacticInt * currentExchangeRate
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: dollarInt)) else { return galactic }
        
        return "$\(formattedNumber)"
    }
    
    // - AurebeshSans-Serif credit
    func galacticWithCommas(from galactic: String) -> String {
        guard let galacticInt = Int(galactic) else { return galactic }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: galacticInt)) else { return galactic }
        return formattedNumber
    }
    
    func addCommas(to number: String) -> String {
        guard let numberInt = Int(number) else { return number }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: numberInt)) else { return number }
        return formattedNumber
    }
}


extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
}
