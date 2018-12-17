//
//  DataModels.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/30/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation

// Characters
class Characters: Codable {
    var results: [Character]
    let count: Int
}

class Character: Codable {
    let birthYear: String
    let eyeColor: String
    let hairColor: String
    var height: String
    let homeworld: String
    let name: String
    let starships: [String]
    let vehicles: [String]
    
    // Uncomment below to test error handling if key is missing
//    let fakeKey: String
}

// Planets
struct Planets: Codable {
    var results: [Planet]
    let count: Int
}

struct Planet: Codable {
    let name: String
    let url: String
    
//    let fakeKey: String
}



// Vehicles
class Vehicles: Codable {
    var results: [Vehicle]
    let count: Int
}

class Vehicle: Codable {
    let name: String
    let model: String
    let manufacturer: String
    let costInCredits: String
    var length: String
    let crew: String
    let vehicleClass: String
    let url: String
    
//    let fakeKey: String
}

// Starships
class Starships: Codable {
    var results: [Starship]
    let count: Int
}

class Starship: Codable {
    let name: String
    let model: String
    let manufacturer: String
    let costInCredits: String
    var length: String
    let crew: String
    let starshipClass: String
    let url: String
    
//    let fakeKey: String
}


// JSON Error Model
struct JSONError {
    let type: StarWarsTypes
    let errorMessage: String
}
