//
//  SaveData.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/13.
//


import Foundation
import SwiftData

@Model
class SaveData {
    var date: Date
    var screen: NovelID
    
    init(date: Date = Date(), screen: NovelID) {
        self.date = date
        self.screen = screen
    }
}
