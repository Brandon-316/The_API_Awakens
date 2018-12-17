//
//  NSNotifications.swift
//  TBA-SA
//
//  Created by Brandon Mahoney on 4/1/18.
//  Copyright © 2018 William Mahoney. All rights reserved.
//

import Foundation

class NSNotifications {
    let jsonCharacterRequestDidComplete = NSNotification.Name(rawValue: "jsonCharacterRequestDidComplete")
    let jsonVehicleRequestDidComplete = NSNotification.Name(rawValue: "jsonVehicleRequestDidComplete")
    let jsonStarshipRequestDidComplete = NSNotification.Name(rawValue: "jsonStarshipRequestDidComplete")
    let jsonPlanetsRequestDidComplete = NSNotification.Name(rawValue: "jsonPlanetsRequestDidComplete")
    let jsonError = NSNotification.Name(rawValue: "jsonError")
    let networkError = NSNotification.Name(rawValue: "networkError")
    
    let pickerDidChange = NSNotification.Name(rawValue: "pickerNotificationDidChange")
}
