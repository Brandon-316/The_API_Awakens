//
//  Protocols.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/29/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation

protocol Nameable {
    var name: String { get set }
}

protocol Characterable: Nameable {
    var birthdate: String { get set }
    
    var home: String { get set }
    
    var heightMetric: Double { get set }
    var heightEnglish: String { get }
    
    var eyeColor: String { get set }
    var hairColor: String { get set }
}

protocol Vehicaleable: Nameable {
    var make: String { get set }
    
    var costCredits: Int { get set }
    var costDollars: Int { get }
    
    var lengthMetric: Double { get set }
    var lengthEnglish: String { get }
    
    var vehicleClass: String { get set }
    
    var crew: Int { get set }
}



