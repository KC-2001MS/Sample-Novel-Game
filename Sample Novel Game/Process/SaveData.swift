//
//  SaveData.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/13.
//


import Foundation
import SwiftData

@Model
class SaveData: Codable {
    var date: Date
    var screen: NovelID
    
    init(date: Date = Date(), screen: NovelID) {
        self.date = date
        self.screen = screen
    }
    
    enum CodingKeys: CodingKey {
        case date
        case screen
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        screen = try container.decode(NovelID.self, forKey: .screen)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(screen, forKey: .screen)
    }
}
