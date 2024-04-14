//
//  AssetsManager.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/02/23.
//


import Foundation
import Observation
import BackgroundAssets
import OSLog

@Observable
class AssetsManager: NSObject {
    var scenes: Array<NovelScene>
    
    override init() {
        self.scenes = []
        super.init()
        BADownloadManager.shared.delegate = self
        self.loadAssets()
    }
    
    
    func delete() {
        try? FileManager.default.removeItem(at: URL.jsonURL)
        scenes = []
    }
    
    func loadAssets() {
        Task { @MainActor in
            let exists = FileManager.default.fileExists(atPath: URL.jsonURL.path(percentEncoded: false))
            if exists {
                scenes = Bundle.main.decodeJSON(URL.jsonURL)
            } else {
                self.startDownload()
            }
        }
    }
    
    private func startDownload() {
        guard let url = URL(string: "https://storage.googleapis.com/novel-game-asset/game.json") else {
            return
        }
        
        BADownloadManager.shared.withExclusiveControl { lockAcquired, error in
            guard lockAcquired else {
                Logger.assets.warning("Failed to acquire lock: \(error)")
                return
            }
            
            do {
                Logger.assets.info("Start download")
                let download: BADownload
                let currentDownloads = try BADownloadManager.shared.fetchCurrentDownloads()
                
                // If this session is already being downloaded, promote it to the foreground.
                if let existingDownload = currentDownloads.first(where: { $0.identifier == "config" }) {
                    download = existingDownload
                    Logger.assets.info("downloading...")
                } else {
                    //https://developer.apple.com/forums/thread/741206
                    download = BAURLDownload(
                        identifier: "config",
                        request: URLRequest(url: url),
                        essential: false,
                        fileSize: Int(0),
                        applicationGroupIdentifier: "group.com.KCs-NovelGameSample-1.Novel-Game-Sample",
                        priority: .default
                    )
                }
                
                guard download.state != .failed else {
                    Logger.assets.warning("Download config is in the failed state.")
                    return
                }
                
                try BADownloadManager.shared.startForegroundDownload(download)
            } catch {
                Logger.assets.warning("Failed to start download for config")
            }
        }
    }
}

extension AssetsManager: BADownloadManagerDelegate {
    func download(_ download: BADownload, finishedWithFileURL fileURL: URL) {
        do {
            Logger.assets.info("Downloaded")
            _ = try FileManager.default.replaceItemAt(URL.jsonURL, withItemAt: fileURL)
            scenes = Bundle.main.decodeJSON(URL.jsonURL)
        } catch {
            Logger.assets.error("Failed to move downloaded file: \(error)")
            return
        }
    }
    
    func download(_ download: BADownload, failedWithError error: Error) {
        guard type(of: download) == BAURLDownload.self else {
            Logger.assets.warning("Download of unsupported type failed: \(download.identifier). \(error)")
            return
        }
        
        Logger.assets.warning("Download failed: \(error)")
    }
    
    func download(_ download: BADownload, didReceive challenge: URLAuthenticationChallenge) async
        -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        return (.performDefaultHandling, nil)
    }
    
    func downloadDidBegin(_ download: BADownload) {
        Logger.assets.info("Began")
    }
    
    func downloadDidPause(_ download: BADownload) {
        Logger.assets.info("Paause")
    }
}
