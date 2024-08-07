//
//  SettingsObject.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/04.
//


import Foundation

@Observable
class SettingsObject {
    let keyValueStore = NSUbiquitousKeyValueStore.default
    
    var talkerFontSize: Float {
        didSet {
            keyValueStore.set(talkerFontSize, forKey: "talkerFontSize")
        }
    }
    
    var quoteFontSize: Float {
        didSet {
            keyValueStore.set(quoteFontSize, forKey: "quoteFontSize")
        }
    }
    
    var voiceVolume: Float {
        didSet {
            keyValueStore.set(voiceVolume, forKey: "voiceVolume")
        }
    }
    var primaryBGMVolume: Float {
        didSet {
            keyValueStore.set(primaryBGMVolume, forKey: "primaryBGMVolume")
        }
    }
    var secondaryBGMVolume: Float {
        didSet {
            keyValueStore.set(secondaryBGMVolume, forKey: "secondaryBGMVolume")
        }
    }
    
    var waitingTime: Double {
        didSet {
            keyValueStore.set(waitingTime, forKey: "waitingTime")
        }
    }
    
    var isDisplayingDialogWhenGoingBack: Bool {
        didSet {
            keyValueStore.set(isDisplayingDialogWhenGoingBack, forKey: "isDisplayingDialogWhenGoingBack")
        }
    }
    
    var isDisplayingDialogWhenLoading: Bool {
        didSet {
            keyValueStore.set(isDisplayingDialogWhenLoading, forKey: "isDisplayingDialogWhenLoading")
        }
    }
    
    func reset() {
        self.talkerFontSize = 15.0
        self.quoteFontSize = 15.0
        self.voiceVolume = 1.0
        self.primaryBGMVolume = 1.0
        self.secondaryBGMVolume = 1.0
        self.waitingTime = 5
        self.isDisplayingDialogWhenGoingBack = false
        self.isDisplayingDialogWhenLoading = false
    }
    
    init() {
        self.talkerFontSize = keyValueStore.object(forKey: "talkerFontSize") as? Float ?? 15.0
        self.quoteFontSize = keyValueStore.object(forKey: "quoteFontSize") as? Float ?? 15.0
        self.voiceVolume = keyValueStore.object(forKey: "voiceVolume") as? Float ?? 1.0
        self.primaryBGMVolume = keyValueStore.object(forKey: "primaryBGMVolume") as? Float ?? 1.0
        self.secondaryBGMVolume = keyValueStore.object(forKey: "secondaryBGMVolume") as? Float ?? 1.0
        self.waitingTime = keyValueStore.object(forKey: "waitingTime") as? Double ?? 5
        self.isDisplayingDialogWhenGoingBack = false
        self.isDisplayingDialogWhenLoading = false
    }
    
    func ExportAppData(data: Array<SaveData>) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let jsonData = try? encoder.encode(data) else {
            fatalError("Failed to encode to JSON.")
        }
        
        return String(bytes: jsonData, encoding: .utf8) ?? ""
    }
    
    func importAppData(url: URL) -> Array<SaveData> {
        //iOSのアクセス権エラーのために追加した部分
        guard url.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return []
        }
        
        // We have to stop accessing the resource no matter what
        defer { url.stopAccessingSecurityScopedResource() }
        //追加部分
        let decoder = JSONDecoder()
        let jsonStr = try! String(contentsOf: url,encoding:.utf8)
        let jsonData = String(jsonStr).data(using: .utf8)!
        
        // JSONデータを構造体に準拠した形式に変換
        let settingData = try! decoder.decode(Array<SaveData>.self, from: jsonData)
        
        return settingData
    }
}
