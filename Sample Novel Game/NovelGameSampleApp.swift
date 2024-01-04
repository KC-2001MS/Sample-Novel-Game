//
//  Novel_Game_SampleApp.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

@main
struct NovelGameSampleApp: App {
    @State var settings = SettingsObject()
    
    var body: some Scene {
        WindowGroup {
            TitleView()
                .environment(settings)
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
                .environment(settings)
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
