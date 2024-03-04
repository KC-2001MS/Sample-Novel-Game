//
//  TitleView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/07.
//


import SwiftUI
import SwiftData

struct TitleView: View {
    @Environment(SettingsObject.self) var settings
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SaveData.date, order: .reverse) private var saveData: Array<SaveData>
    
    @State private var isOpeningSettings = false
    @State private var isOpenHelp = false
    
    @State private var assetsManager = AssetsManager()

    init() {
        self.isOpeningSettings = false
    }
    
    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            VStack {
                Text("Sample Novel Game")
                    .font(.largeTitle)
                    .bold()
                    .shadow(radius: 15)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                NavigationLink(destination: GameView(scenes: assetsManager.scenes, id: NovelID())) {
                    Text("Start")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
                .disabled(assetsManager.scenes.isEmpty)
                
                NavigationLink(destination: GameView(scenes: assetsManager.scenes, id: saveData.first?.screen ?? NovelID())) {
                    Text("Continue")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
                .disabled(saveData.isEmpty || assetsManager.scenes.isEmpty)

#if os(macOS)
                SettingsLink {
                    Text("Settings")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
#else
                Button(action: {
                    isOpeningSettings.toggle()
                }) {
                    Text("Settings")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
#endif
            }
            .padding(.vertical, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaledToFill()
            }
        }
#if !os(macOS)
        .sheet(isPresented: $isOpeningSettings) {
            SettingsView()
        }
        .sheet(isPresented: $isOpenHelp) {
            HelpView()
        }
#endif
        .preferredColorScheme(.dark)
        .focusedSceneValue(\.waitingTime, $settings.waitingTime)
        .focusedValue(\.helpAction) {
            isOpenHelp.toggle()
        }
    }
}

#Preview {
    TitleView()
}
