//
//  BackgroundDownloadHandler.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/02/23.
//


import BackgroundAssets
import OSLog

@main
struct BackgroundDownloadHandler: BADownloaderExtension
{
    func downloads(for request: BAContentRequest,
                   manifestURL: URL,
                   extensionInfo: BAAppExtensionInfo) -> Set<BADownload>
    {
        let appGroupIdentifier = "group.com.KCs-NovelGameSample-1.Novel-Game-Sample"

        var downloadsToSchedule: Set<BADownload> = []
        
        switch (request) {
        case .install, .update:
            let essentialDownload = BAURLDownload(
                identifier: "config",
                request: URLRequest(url: manifestURL),
                essential: true,
                fileSize: Int(5656),
                applicationGroupIdentifier: appGroupIdentifier,
                priority: .default)

            downloadsToSchedule.insert(essentialDownload)
            break;
        case .periodic:
            let nonEssentialDownload = BAURLDownload(
                identifier: "config",
                request: URLRequest(url: manifestURL),
                essential: false,
                fileSize: Int(0),
                applicationGroupIdentifier: appGroupIdentifier,
                priority: .default)

            downloadsToSchedule.insert(nonEssentialDownload)
            break;

        @unknown default:
            return Set()
        }

        return downloadsToSchedule
    }

    func backgroundDownload(_ failedDownload: BADownload, failedWithError error: Error) {
        guard type(of: failedDownload) == BAURLDownload.self else {
            Logger.ext.warning("Download of unsupported type failed: \(failedDownload.identifier). \(error)")
            return
        }
        
        if failedDownload.isEssential {
            Logger.ext.warning("Rescheduling failed download: \(failedDownload.identifier). \(error)")
            do {
                let optionalDownload = failedDownload.removingEssential()
                try BADownloadManager.shared.scheduleDownload(optionalDownload)
            } catch {
                Logger.ext.warning("Failed to reschedule download \(failedDownload.identifier). \(error)")
            }
        } else {
            Logger.ext.warning("Download failed: \(failedDownload.identifier). \(error)")
        }
    }

    func backgroundDownload(_ finishedDownload: BADownload, finishedWithFileURL fileURL: URL) {
        BADownloadManager.shared.withExclusiveControl { controlAcquired, error in
            guard controlAcquired else {
                Logger.ext.warning("Failed to acquire lock: \(error)")
                return
            }

            do {
                try FileManager.default.moveItem(at: fileURL, to: URL.jsonURL)
            } catch {
                Logger.ext.error("Download finished, however the move from the ephemeral file location to the final destination failed. \(error)")
                return
            }
            
            Logger.ext.log("Download finished: \(finishedDownload.identifier)")
        }
    }
    
    func backgroundDownload(_ download: BADownload, didReceive challenge: URLAuthenticationChallenge) async
        -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        return (.performDefaultHandling, nil)
    }
}
