//
//  NovelGameChoiceButtonStyle.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/09.
//


import SwiftUI

struct NovelGameChoiceButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 200)
            .padding()
            .buttonStyle(.borderless)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Material.ultraThin)
            }
    }
 }

#Preview {
    Button(action: {
        
    }) {
        Text("Button")
    }
    .buttonStyle(NovelGameChoiceButtonStyle())
}
