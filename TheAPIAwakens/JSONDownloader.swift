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
    
    func downloadJSON(for object: StarWarsTypes) {
        var temporaryResults: [Any] = [Any]()
        var totalPages = 0
        
        guard let url: URL = URL(string: "https://swapi.co/api/\(object.urlString)/") else { return }
        let session: URLSession = URLSession.shared
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    switch object {
                        case .characters:
                            let objects = try! decoder.decode(Characters.self, from: data)
                            temporaryResults.append(contentsOf: objects.results)
                            totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                        case .starships:
                            let objects = try! decoder.decode(Starships.self, from: data)
                            temporaryResults.append(contentsOf: objects.results)
                            totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                        case .vehicles:
                            let objects = try! decoder.decode(Vehicles.self, from: data)
                            temporaryResults.append(contentsOf: objects.results)
                            totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                        case .planets:
                            let objects = try! decoder.decode(Planets.self, from: data)
                            temporaryResults.append(contentsOf: objects.results)
                            totalPages = self.calculateNumberOfPages(with: objects.count, pageMax: objects.results.count)
                    }
                }
            }
            
            if totalPages > 1 {
                DispatchQueue.global(qos: .userInitiated).async {
                    let downloadGroup = DispatchGroup()
                    for page in stride(from: 2, through: totalPages, by: 1) {
                        guard let url: URL = URL(string: "https://swapi.co/api/\(object.urlString)/?page=\(page)") else { print("Returned"); return }
                        let session: URLSession = URLSession.shared
                        
                        downloadGroup.enter()
                        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
                            
                            if let error = error {
                                print("There was an error")
                                print(error.localizedDescription)
                            }
                            
                            if let urlLocation = urlLocation {
                                if let data = try? Data(contentsOf: urlLocation) {
                                    let decoder = JSONDecoder()
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                    
                                    switch object {
                                        case .characters:
                                            let objects = try! decoder.decode(Characters.self, from: data)
                                            temporaryResults.append(contentsOf: objects.results)
                                        case .starships:
                                            let objects = try! decoder.decode(Starships.self, from: data)
                                            temporaryResults.append(contentsOf: objects.results)
                                        case .vehicles:
                                            let objects = try! decoder.decode(Vehicles.self, from: data)
                                            temporaryResults.append(contentsOf: objects.results)
                                        case .planets:
                                            let objects = try! decoder.decode(Planets.self, from: data)
                                            temporaryResults.append(contentsOf: objects.results)
                                    }
                                    
                                    downloadGroup.leave()
                                }
                            }
                        }
                        task.resume()
                    }
                    downloadGroup.wait()
                    
                    DispatchQueue.main.async {
                        switch object {
                            case .characters: NotificationCenter.default.post(name: NSNotifications().jsonCharacterRequestDidComplete, object: temporaryResults)
                            case .starships: NotificationCenter.default.post(name: NSNotifications().jsonStarshipRequestDidComplete, object: temporaryResults)
                            case .vehicles: NotificationCenter.default.post(name: NSNotifications().jsonVehicleRequestDidComplete, object: temporaryResults)
                            case .planets: NotificationCenter.default.post(name: NSNotifications().jsonPlanetsRequestDidComplete, object: temporaryResults)
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
    
    func calculateNumberOfPages(with totalObjects: Int, pageMax: Int) -> Int {
        if totalObjects < pageMax { return 1 }
        return Int(round(Double(totalObjects) / Double(pageMax)))
    }
    
}
