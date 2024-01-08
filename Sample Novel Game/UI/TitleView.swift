//
//  TitleView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/07.
//


import SwiftUI

struct TitleView: View {
    @State private var isOpeningSettings = false
    
    let scenes: Array<NovelScene>
    
    init() {
        self.isOpeningSettings = false
        self.scenes = Bundle.main.decodeJSON("game.json")
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
                        .font(.title)
                        .frame(width: 200)
                        .padding()
                        .foregroundStyle(Color.white)
                }
                .buttonStyle(.borderless)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Material.ultraThin)
                }
                
#if os(macOS)
                SettingsLink {
                    Text("Settings")
                        .font(.title)
                        .frame(width: 200)
                        .padding()
                        .foregroundStyle(Color.white)
                }
                .buttonStyle(.borderless)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Material.ultraThin)
                }
#else
                Button(action: {
                    isOpeningSettings.toggle()
                }) {
                    Text("Settings")
                        .font(.title)
                        .frame(width: 200)
                        .padding()
                        .foregroundStyle(Color.white)
                }
                .buttonStyle(.borderless)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Material.ultraThin)
                }
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
