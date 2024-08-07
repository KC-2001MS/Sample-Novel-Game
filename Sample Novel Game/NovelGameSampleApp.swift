//
//  Novel_Game_SampleApp.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI
import SwiftData

@main
struct NovelGameSampleApp: App {
    @State var settings = SettingsObject()
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: SaveData.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TitleView()
                .environment(settings)
                .modelContainer(modelContainer)
        }
        .commands {
            BasicCommands()
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
        
#if os(macOS)
        Window("Sample Novel Game", id: "help") {
            HelpView()
        }
        
        Settings {
            SettingsView()
                .environment(settings)
                .modelContainer(modelContainer)
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
