//
//  TitleView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/07.
//


import SwiftUI

struct TitleView: View {
    let scenes: Array<NovelScene>
    
    init() {
        self.scenes = Bundle.main.decodeJSON("game.json")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Novel Game Sample")
                    .font(.largeTitle)
                
                Spacer()
                
                NavigationLink(destination: GameView(scenes: scenes, id: NovelID())) {
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
            }
            .padding()
            .padding(.vertical, 100)
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
