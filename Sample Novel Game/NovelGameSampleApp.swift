//
//  Novel_Game_SampleApp.swift
//  Novel Game Sample
//  
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

@main
struct NovelGameSampleApp: App {
    var body: some Scene {
        WindowGroup {
            TitleView()
        }
        .commands {
            BasicCommands()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
