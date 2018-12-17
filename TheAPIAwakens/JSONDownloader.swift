//
//  JSONDownloader.swift
//  TheAPIAwakens
//
//  Created by Brandon Mahoney on 11/30/18.
//  Copyright © 2018 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter


class JSONDownloader {
    
    // Start JSON request
    func downloadJSON(for object: StarWarsTypes) {
        var temporaryResults: [Any] = [Any]()
        var totalPages = 0
        var jsonError: Error?
        
        guard let url: URL = URL(string: "https://swapi.co/api/\(object.urlString)/") else { return }
        let session: URLSession = URLSession.shared
        
        // Get first page of data
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            
            if let error = error {
                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
            }
            
            // Decode data and calculate total number of pages
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    switch object {
                        case .characters:
                            do {
                                let objects = try decoder.decode(Characters.self, from: data)
                                temporaryResults.append(contentsOf: objects.results)
                                totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                            } catch {
                                jsonError = error
                            }
                        case .starships:
                            do {
                                let objects = try decoder.decode(Starships.self, from: data)
                                temporaryResults.append(contentsOf: objects.results)
                                totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                            } catch {
                                jsonError = error
                            }
                        case .vehicles:
                            do {
                                let objects = try decoder.decode(Vehicles.self, from: data)
                                temporaryResults.append(contentsOf: objects.results)
                                totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                            } catch {
                                jsonError = error
                            }
                        case .planets:
                            do {
                                let objects = try decoder.decode(Planets.self, from: data)
                                temporaryResults.append(contentsOf: objects.results)
                                totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                            } catch {
                                jsonError = error
                        }
                    }
                }
            }
            
            // Get all other pages of data if there are any
            if totalPages > 1 {
                DispatchQueue.global(qos: .userInitiated).async {
                    let downloadGroup = DispatchGroup()
                    for page in stride(from: 2, through: totalPages, by: 1) {
                        guard let url: URL = URL(string: "https://swapi.co/api/\(object.urlString)/?page=\(page)") else { return }
                        let session: URLSession = URLSession.shared
                        
                        downloadGroup.enter()
                        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
                            
                            if let error = error {
                                NotificationCenter.default.post(name: NSNotifications().networkError, object: error.localizedDescription)
                            }
                            
                            if let urlLocation = urlLocation {
                                if let data = try? Data(contentsOf: urlLocation) {
                                    let decoder = JSONDecoder()
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                    
                                    switch object {
                                        case .characters:
                                            do {
                                                let objects = try decoder.decode(Characters.self, from: data)
                                                temporaryResults.append(contentsOf: objects.results)
                                            } catch {
                                                jsonError = error
                                            }
                                        case .starships:
                                            do {
                                                let objects = try decoder.decode(Starships.self, from: data)
                                                temporaryResults.append(contentsOf: objects.results)
                                            } catch {
                                                jsonError = error
                                            }
                                        case .vehicles:
                                            do {
                                                let objects = try decoder.decode(Vehicles.self, from: data)
                                                temporaryResults.append(contentsOf: objects.results)
                                            } catch {
                                                jsonError = error
                                            }
                                        case .planets:
                                            do {
                                                let objects = try decoder.decode(Planets.self, from: data)
                                                temporaryResults.append(contentsOf: objects.results)
                                            } catch {
                                                jsonError = error
                                            }
                                    }
                                    
                                    downloadGroup.leave()
                                }
                            }
                        }
                        task.resume()
                    }
                    downloadGroup.wait()
                    
                    // All pages are complete task
                    DispatchQueue.main.async {
                        switch object {
                            case .characters:
                                self.completeTask(notification: NSNotifications().jsonCharacterRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .characters)
                            case .starships:
                                self.completeTask(notification: NSNotifications().jsonStarshipRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .starships)
                            case .vehicles:
                                self.completeTask(notification: NSNotifications().jsonVehicleRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .vehicles)
                            case .planets:
                                self.completeTask(notification: NSNotifications().jsonPlanetsRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .planets)
                        }
                    }
                }
            } else {
                // If there are no more pages than the first one then complete task
                switch object {
                    case .characters:
                        self.completeTask(notification: NSNotifications().jsonCharacterRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .characters)
                    case .starships:
                        self.completeTask(notification: NSNotifications().jsonStarshipRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .starships)
                    case .vehicles:
                        self.completeTask(notification: NSNotifications().jsonVehicleRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .vehicles)
                    case .planets:
                        self.completeTask(notification: NSNotifications().jsonPlanetsRequestDidComplete, error: jsonError, temporaryResults: temporaryResults, type: .planets)
                }
            }
        }
        task.resume()
    }
    
    
    func calculateNumberOfPages(with totalObjects: Int, pageMax: Int) -> Int {
        if totalObjects < pageMax { return 1 }
        return Int(round(Double(totalObjects) / Double(pageMax)))
    }
    
    func completeTask(notification: NSNotification.Name, error: Error?, temporaryResults: [Any], type: StarWarsTypes) {
        if let error = error {
            let jsonError = JSONError.init(type: type, errorMessage: error.localizedDescription)
            NotificationCenter.default.post(name: NSNotifications().jsonError, object: jsonError)
        }
        NotificationCenter.default.post(name: notification, object: temporaryResults)
    }
    
//    func postError(notification: NSNotification.Name, jsonError: JSONError, temporaryResults: [Any]) {
//        NotificationCenter.default.post(name: notification, object: temporaryResults)
//        NotificationCenter.default.post(name: NSNotifications().jsonError, object: jsonError)
//    }
//
//    func completeJSONTask(with notification: NSNotification.Name, jsonError: JSONError, temporaryResults: [Any]) {
//        NotificationCenter.default.post(name: notification, object: temporaryResults)
//        NotificationCenter.default.post(name: NSNotifications().jsonError, object: jsonError)
//    }
    
}
