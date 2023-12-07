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
final class NovelControler: NSObject, AVAudioPlayerDelegate {
    let sceneList: Array<SceneInfo>
    
    @ObservationIgnored
    var num: Int = 1
    
    var isPlaying = false
    
    var isAutoPlay = false
    
    @ObservationIgnored
    var endAction: () -> Void
    
    var talker = ""
    
    var quote = ""
    
    var characters: Array<String> = []
    
    var background = ""
    
    @ObservationIgnored
    private var voicePlayer: AVAudioPlayer? = nil
    
    @ObservationIgnored
    private var primaryBGMPlayer: AVAudioPlayer? = nil
    
    @ObservationIgnored
    private var secondaryBGMPlayer: AVAudioPlayer? = nil
    
    init(sceneList: Array<SceneInfo>) {
        self.isPlaying = false
        self.sceneList = sceneList
        self.endAction = {}
        self.talker = sceneList.first?.talker ?? ""
        self.quote = sceneList.first?.quote ?? ""
        self.characters = sceneList.first?.characters ?? []
        self.background = sceneList.first?.background ?? ""
        self.num = 1
        self.voicePlayer = nil
        self.primaryBGMPlayer = nil
        self.secondaryBGMPlayer = nil
        //        ここで再生した音は切り替わらないので保留
        //        playLoopingSound(player: &primaryBGMPlayer, assetName: sceneList.first?.primaryBGM ?? "")
        //        playLoopingSound(player: &secondaryBGMPlayer, assetName: sceneList.first?.secondaryBGM ?? "")
        //        playSound(player: &voicePlayer, assetName: sceneList.first?.voice ?? "")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        if isAutoPlay && num < sceneList.count {
            next()
        } else if num >= sceneList.count  {
            endAction()
            print("---------")
            print(num)
            print("---------")
            print("end")
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
    
    func next() {
        if let scene = sceneList[safe: num] {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.background = scene.background ?? ""
        }
        self.num += 1
        print(num)
    }
    
    func last() {
        if let scene = sceneList.last {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.background = scene.background ?? ""
            self.num = sceneList.count
        }
    }
    
    func back() {
        if let scene = sceneList[safe: num - 2] {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.background = scene.background ?? ""
        }
        self.num -= 1
    }
    
    func first() {
        if let scene = sceneList.first {
            playLoopingSound(player: &primaryBGMPlayer, assetName: scene.primaryBGM ?? "")
            playLoopingSound(player: &secondaryBGMPlayer, assetName: scene.secondaryBGM ?? "")
            playSound(player: &voicePlayer, assetName: scene.voice ?? "")
            self.talker = scene.talker ?? ""
            self.quote = scene.quote ?? ""
            self.background = scene.background ?? ""
            self.num = 1
        }
    }
    
    var canNotBack: Bool {
        num - 1 < 1
    }
    
    var canNotNext: Bool {
        num >= sceneList.count
    }
}


class SceneInfo: Codable {
    var talker: String?
    var quote: String?
    var characters: Array<String>
    var background: String?
    var voice: String?
    var primaryBGM: String?
    var secondaryBGM: String?
    
    init(
        talker: String? = nil,
        quote: String? = nil,
        characters: Array<String> = [],
        background: String? = nil,
        voice: String? = nil,
        primaryBGM: String? = nil,
        secondaryBGM: String? = nil
    ) {
        self.talker = talker
        self.quote = quote
        self.characters = characters
        self.background = background
        self.voice = voice
        self.primaryBGM = primaryBGM
        self.secondaryBGM = secondaryBGM
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
