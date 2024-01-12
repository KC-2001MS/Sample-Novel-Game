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
    
    let initID: NovelID?
    
    var id: NovelID?
    
    var nextID: NovelID?
    
    @ObservationIgnored
    var num: Int
    
    var talker: String
    
    var quote: String
    
    var characters: Array<String>
    
    var choices: Array<NovelChoice>?
    
    var background: String
    
    @ObservationIgnored
    private var voicePlayer: AVAudioPlayer?
    
    var BGMName: String
    
    @ObservationIgnored
    private var BGMPlayer: AVAudioPlayer?
    
    @ObservationIgnored
    private var soundEffectPlayer: AVAudioPlayer?
    
    var time: Double
    
    var isPlaying: Bool
    
    var isAutoPlay: Bool
    
    @ObservationIgnored
    var endAction: () -> Void
    
    var autoplayTime: Double
    
    init(scenes: Array<NovelScene>, id: NovelID) {
        self.scenes = scenes
        self.screens = []
        self.initID = id
        self.id = nil
        self.nextID = nil
        self.num = 0
        self.talker = ""
        self.quote = ""
        self.characters = []
        self.choices = nil
        self.background = ""
        self.voicePlayer = nil
        self.BGMName = ""
        self.BGMPlayer = nil
        self.soundEffectPlayer = nil
        self.time = 0
        self.isPlaying = false
        self.isAutoPlay = false
        self.endAction = {}
        self.autoplayTime = 0.0
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        if isAutoPlay && num < screens.count {
            next()
        } else if num >= screens.count  {
            endAction()
        }
    }
    
    private func playLoopingSound( player: inout AVAudioPlayer?,assetName: String?) {
        if let name = assetName {
            if let dataAsset = NSDataAsset(name: name) {
                do {
                    player?.stop()
                    player = try AVAudioPlayer(data: dataAsset.data)
                    player?.numberOfLoops = -1
                    player?.prepareToPlay()
                    player?.play()
                } catch {
                    print("音楽ファイルの再生に失敗しました")
                }
            } else {
                player?.stop()
                player = nil
            }
        }
    }
    
    private func playSound( player: inout AVAudioPlayer?,assetName: String?) {
        if let name = assetName {
            if let dataAsset = NSDataAsset(name: name) {
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
            } else {
                player?.stop()
               player = nil
            }
        }
    }
    
    func autoPlay() {
        isAutoPlay.toggle()
        next()
    }
    
    func stopPlayAll() {
        voicePlayer?.stop()
        BGMPlayer?.stop()
        soundEffectPlayer?.stop()
    }
    
    func startPlayAll() {
        if let scene = scenes.first(where: { $0.id == initID }) {
            screens = scene.screens
        }
        id = initID
    }
    
    func next() {
        if let scene = screens[safe: num] {
            playLoopingSound(player: &BGMPlayer, assetName: scene.BGM?.assetName)
            playLoopingSound(player: &soundEffectPlayer, assetName: scene.soundEffect)
            playSound(player: &voicePlayer, assetName: scene.voice)
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.BGMName = scene.BGM?.name ?? BGMName
            self.choices = scene.choices
            self.num += 1
            self.time =  (voicePlayer?.duration ?? 0) + Double(scene.additionalTime ?? 100)
            self.nextID = scene.nextID
        } else {
            if nextID != nil && choices == nil {
                id = nextID
                if let scene = scenes.first(where: { $0.id == nextID && $0.id.isEmptyChoice()}) {
                    screens = scene.screens
                }
                nextID = nil
            }
        }
    }
    
    func last() {
        if let scene = screens.last {
            playLoopingSound(player: &BGMPlayer, assetName: scene.BGM?.assetName)
            playLoopingSound(player: &soundEffectPlayer, assetName: scene.soundEffect)
            playSound(player: &voicePlayer, assetName: scene.voice)
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.BGMName = scene.BGM?.name ?? BGMName
            self.choices = scene.choices
            self.num = screens.count
            self.time = Double(scene.additionalTime ?? 100)
            self.nextID = scene.nextID
        }
    }
    
    func back() {
        if let scene = screens[safe: num - 2] {
            playLoopingSound(player: &BGMPlayer, assetName: scene.BGM?.assetName)
            playLoopingSound(player: &soundEffectPlayer, assetName: scene.soundEffect)
            playSound(player: &voicePlayer, assetName: scene.voice)
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.BGMName = scene.BGM?.name ?? BGMName
            self.choices = scene.choices
            self.num -= 1
            self.time = Double(scene.additionalTime ?? 100)
            self.nextID = scene.nextID
        }
    }
    
    func first() {
        if let scene = screens.first {
            playLoopingSound(player: &BGMPlayer, assetName: scene.BGM?.assetName)
            playLoopingSound(player: &soundEffectPlayer, assetName: scene.soundEffect)
            playSound(player: &voicePlayer, assetName: scene.voice)
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.characters = scene.characters
            self.background = scene.background ?? ""
            self.BGMName = scene.BGM?.name ?? BGMName
            self.choices = scene.choices
            self.num = 1
            self.time = Double(scene.additionalTime ?? 100)
            self.nextID = scene.nextID
        }
    }
    
    func choice(choice: NovelChoice) {
        nextID?.choice = choice.num
        if let scene = scenes.first(where: { $0.id == nextID}) {
            print(scene)
            screens = scene.screens
            id = nextID
        }
    }
    
    
    var canNotBack: Bool {
        num - 1 < 1
    }
    
    var canNotNext: Bool {
        num >= screens.count && choices != nil
    }
}

class NovelScreen: Codable {
    var talker: String?
    var quote: String?
    var choices: Array<NovelChoice>?
    var characters: Array<String>
    var background: String?
    var voice: String?
    var BGM: NovelBGM?
    var soundEffect: String?
    var additionalTime: Int?
    var nextID: NovelID?
    
    init(
        talker: String? = nil,
        quote: String? = nil,
        choices: Array<NovelChoice>? = nil,
        characters: Array<String> = [],
        background: String? = nil,
        voice: String? = nil,
        BGM: NovelBGM? = nil,
        soundEffect: String? = nil,
        additionalTime: Int? = nil,
        nextNum: NovelID? = nil
    ) {
        self.talker = talker
        self.quote = quote
        self.choices = choices
        self.characters = characters
        self.background = background
        self.voice = voice
        self.BGM = BGM
        self.soundEffect = soundEffect
        self.additionalTime = additionalTime
        self.nextID = nextNum
    }
}

class NovelScene: Codable {
    var id: NovelID
    var screens: Array<NovelScreen> = []
}

class NovelBGM: Codable {
    var name: String?
    var assetName: String
}

class NovelChoice: Codable, Identifiable {
    var word: String
    var num: Int?
}

class NovelID: Codable, Equatable {
    static func == (lhs: NovelID, rhs: NovelID) -> Bool {
        return lhs.section == rhs.section && lhs.chapter == rhs.chapter && lhs.part == rhs.part && lhs.choice == rhs.choice
    }
    
    func isEmptyChoice() -> Bool {
        choice == nil
    }
    
    var part: Int
    var chapter: Int
    var section: Int
    var choice: Int?
    var rute: Int?
    
    var chapterAndSection: String {
        "\(chapter) - \(section)"
    }
    
    init(part: Int, chapter: Int, section: Int, choice: Int? = nil, rute: Int? = nil) {
        self.part = part
        self.section = section
        self.chapter = chapter
        self.choice = choice
        self.rute = rute
    }
    
    convenience init() {
        self.init(part: 1, chapter: 1, section: 1)
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
