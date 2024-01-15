//
//  TitleView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/07.
//


import SwiftUI
import SwiftData

struct TitleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SaveData.date) private var saveData: Array<SaveData>
    
    @State private var isOpeningSettings = false
    
    
    let scenes: Array<NovelScene>
    
    init() {
        self.scenes = Bundle.main.decodeJSON("game.json")
        self.isOpeningSettings = false
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Sample Novel Game")
                    .font(.largeTitle)
                    .bold()
                    .shadow(radius: 15)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                NavigationLink(destination: GameView(scenes: scenes, id: NovelID())) {
                    Text("Start")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
                
                NavigationLink(destination: GameView(scenes: scenes, id: saveData.first?.screen ?? NovelID())) {
                    Text("Continue")
                }
                .buttonStyle(NovelGameTitleButtonStyle())
                .disabled(saveData.first?.screen == nil)
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
        //        .ignoresSafeArea()
#if !os(macOS)
        .sheet(isPresented: $isOpeningSettings) {
            SettingsView()
        }
#endif
    }
}

#Preview {
    TitleView()
}
