//
//  URL+.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/03/05.
//


import Foundation

private let appGroupIdentifier = {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let identifier = infoDictionary["AppGroupIdentifier"] as? String else {
        fatalError("Failed to retrieve App Group Identifier from Info.plist.")
    }

    return identifier
}()

extension URL {
    static let sharedResourcesURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)!
    
    static let assetsStorageURL = {
        let url = sharedResourcesURL.appending(component: "Assets", directoryHint: .isDirectory)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        } catch {
            fatalError("Failed to create session storage directory: \(error)")
        }
        
        return url
    }()
    
    static let jsonURL = assetsStorageURL.appending(path: "game.json")
}

