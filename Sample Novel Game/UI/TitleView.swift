//
//  TitleView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/07.
//


import SwiftUI

struct TitleView: View {
    let sceneList: Array<SceneInfo> = Bundle.main.decodeJSON("game.json")
    
    var body: some View {
        NavigationStack {
            VStack() {
                Spacer()
                    .frame(height: 100)
                Text("Novel Game Sample")
                    .font(.largeTitle)
                
                Spacer()
                
                NavigationLink(destination: GameView(sceneList: sceneList)) {
                    Text("Start")
                        .font(.title)
                        .frame(width: 200)
                        .padding()
                }
                .buttonStyle(.borderless)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Material.ultraThin)
                }
                
                Spacer()
                    .frame(height: 100)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    TitleView()
}
