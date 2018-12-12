//
//  DatabaseService.swift
//  TBA-SA
//
//  Created by Brandon Mahoney on 3/31/18.
//  Copyright © 2018 William Mahoney. All rights reserved.
//

import Foundation
import UIKit

class DatabaseService {
    
    static let shared = DatabaseService()
    private init() {}
    
    let scoreCards: String = "scoreCards"
    
    
    
}

enum StarWarsTypes {
    case characters
    case starships
    case vehicles
    case planets
    
    
    var urlString: String {
        switch self {
            case .characters: return "people"
            case .starships: return "starships"
            case .vehicles: return "vehicles"
            case .planets: return "planets"
        }
    }
    
    var naveTitle: String {
        switch self {
            case .characters: return "Characters"
            case .starships: return "Starships"
            case .vehicles: return "Vehicles"
            case .planets: return "Planets"
        }
    }
}
