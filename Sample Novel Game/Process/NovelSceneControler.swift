//
//  NovelControler.swift
//  Novel Game Sample
//  
//  Created by Keisuke Chinone on 2023/12/06.
//


import Foundation
import Observation
import AVFoundation
import SwiftUI

@Observable
final class NovelSceneControler: NSObject, AVAudioPlayerDelegate {
    let scenes: Array<NovelScene>
    
    var screens: Array<NovelScreen> {
        didSet {
            num = 0
            next()
        }
    }
    
    var id: NovelID? = nil
    
    @ObservationIgnored
    var num: Int = 1
    
    var talker = ""
    
    var quote = ""
    
    var characters: Array<String> = []
    
    var choices: Array<NovelChoice>? = nil
    
    var background = ""
    
    @ObservationIgnored
    private var voicePlayer: AVAudioPlayer? = nil
    
    @ObservationIgnored
    private var primaryBGMPlayer: AVAudioPlayer? = nil
    
    @ObservationIgnored
    private var secondaryBGMPlayer: AVAudioPlayer? = nil
    
    var time: Double = 0
    
    var isPlaying = false
    
    var isAutoPlay = false
    
    @ObservationIgnored
    var endAction: () -> Void
    
    var autoplayTime: Double = 0.0
    
    init(scenes: Array<NovelScene>,screens: Array<NovelScreen>) {
        self.scenes = scenes
        self.screens = screens
        self.num = 1
        self.talker = screens.first?.talker ?? ""
        self.quote = screens.first?.quote ?? ""
        self.characters = screens.first?.characters ?? []
        self.choices = nil
        self.background = screens.first?.background ?? ""
        self.voicePlayer = nil
        self.primaryBGMPlayer = nil
        self.secondaryBGMPlayer = nil
        self.time = Double(screens.first?.additionalTime ?? 100)
        self.isPlaying = false
        self.isAutoPlay = false
        self.endAction = {}
        self.autoplayTime = 0.0
    }
    
    convenience init(scenes: Array<NovelScene>,id: NovelID) {
        let scene = scenes.first(where: { $0.id == id && $0.id.choice == nil})
        self.init(scenes: scenes,screens: scene?.screens ?? [])
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        if isAutoPlay && num < screens.count {
            next()
        } else if num >= screens.count  {
            endAction()
        }
    }
    
    private func playLoopingSound( player: inout AVAudioPlayer?,assetName: String) {
        if let dataAsset = NSDataAsset(name: assetName) {
            do {
                player?.stop()
                player = try AVAudioPlayer(data: dataAsset.data)
                player?.numberOfLoops = -1
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("音楽ファイルの再生に失敗しました")
            }
        }
    }
    
    private func playSound( player: inout AVAudioPlayer?,assetName: String) {
        if let dataAsset = NSDataAsset(name: assetName) {
            do {
                player?.stop()
                player  = try AVAudioPlayer(data: dataAsset.data)
                player?.delegate = self
                player?.prepareToPlay()
                player?.currentTime = 0.0
                player?.volume = 1.0
                player?.play()
            } catch {
                print("音楽ファイルの再生に失敗しました")
            }
        }
    }
    
    func autoPlay() {
        isAutoPlay.toggle()
        next()
    }
    
    func stopPlayAll() {
        voicePlayer?.stop()
        primaryBGMPlayer?.stop()
        secondaryBGMPlayer?.stop()
    }
    
    func startPlayAll() {
        if let scene = screens.first {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
        }
    }
    
    func next() {
        if let scene = screens[safe: num] {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.choices = scene.choices
            self.num += 1
            self.time =  voicePlayer?.duration ?? 0 + Double(scene.additionalTime ?? 100)
            self.id = scene.nextID
        } else {
            if let nextID = id, choices == nil {
                if let scene = scenes.first(where: { $0.id == nextID && $0.id.choice == nil}) {
                    screens = scene.screens
                }
            }
        }
        print(num)
    }
    
    func last() {
        if let scene = screens.last {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.choices = scene.choices
            self.num = screens.count
            self.time = Double(scene.additionalTime ?? 100)
            self.id = scene.nextID
        }
    }
    
    func back() {
        if let scene = screens[safe: num - 2] {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.choices = scene.choices
            self.num -= 1
            self.time = Double(scene.additionalTime ?? 100)
            self.id = scene.nextID
        }
    }
    
    func first() {
        if let scene = screens.first {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.choices = scene.choices
            self.num = 1
            self.time = Double(scene.additionalTime ?? 100)
            self.id = scene.nextID
        }
    }
    
    func choice(choice: NovelChoice) {
        if let scene = scenes.first(where: { $0.id == id && $0.id.choice == choice.num}) {
            print(scene)
            screens = scene.screens
        }
    }
    
    
    var canNotBack: Bool {
        num - 1 < 1
    }
    
    var canNotNext: Bool {
        num >= screens.count && id == nil
    }
}

class NovelScreen: Codable {
    var talker: String?
    var quote: String?
    var choices: Array<NovelChoice>?
    var characters: Array<String>
    var background: String?
    var voice: String?
    var primaryBGM: String?
    var secondaryBGM: String?
    var additionalTime: Int?
    var nextID: NovelID?
    
    init(
        talker: String? = nil,
        quote: String? = nil,
        choices: Array<NovelChoice>? = nil,
        characters: Array<String> = [],
        background: String? = nil,
        voice: String? = nil,
        primaryBGM: String? = nil,
        secondaryBGM: String? = nil,
        additionalTime: Int? = nil,
        nextNum: NovelID? = nil
    ) {
        self.talker = talker
        self.quote = quote
        self.choices = choices
        self.characters = characters
        self.background = background
        self.voice = voice
        self.primaryBGM = primaryBGM
        self.secondaryBGM = secondaryBGM
        self.additionalTime = additionalTime
        self.nextID = nextNum
    }
}

class NovelScene: Codable {
    var id: NovelID
    var screens: Array<NovelScreen> = []
}

class NovelChoice: Codable, Identifiable {
    var word: String
    var num: Int?
}

class NovelID: Codable, Equatable {
    static func == (lhs: NovelID, rhs: NovelID) -> Bool {
        return lhs.primary == rhs.primary && lhs.secondary == rhs.secondary && lhs.tertiary == rhs.tertiary
    }
    
    var primary: Int
    var secondary: Int
    var tertiary: Int
    var choice: Int?
    var rute: Int?
    
    init(primary: Int, secondary: Int, tertiary: Int, choice: Int? = nil, rute: Int? = nil) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.choice = choice
        self.rute = rute
    }
    
    init() {
        self.primary = 1
        self.secondary = 1
        self.tertiary = 1
        self.choice = nil
        self.rute = nil
    }
}

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Bundle {
    /// Jsonファイルのデコードを行い、``Codable``に準拠した構造体に変換する関数
    ///
    ///jsonファイルからSwiftの構造体を生成できます。以下のコードを利用して変換が可能です。
    ///```swift
    ///    let initialValue: InitialValueData =  Bundle.main.decodeJSON("InitialValue.json")
    ///```
    ///この例では、引数ににjsonファイルを指定することによって、initialValue変数にInitialValueData型の構造体としてJSONファイル値を代入することができます。
    ///
    ///ただし、InitialValueDataが完全に``Decodable``に準拠している必要があります。さらに、構造体にjsonファイル側に存在しない変数があるとクラッシュするので注意してください。
    ///
    /// - Parameter file: デコードを行うJSONファイルの文字列
    /// - Returns: Codableに準拠する構造体
    func decodeJSON<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Faild to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
