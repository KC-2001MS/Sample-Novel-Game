//
//  NovelGameTitleButtonStyle.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/08.
//


import SwiftUI

struct NovelGameTitleButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(width: 200)
            .padding()
            .foregroundStyle(configuration.isPressed ? Color.gray : Color.white)
            .buttonStyle(.borderless)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(configuration.isPressed ? Material.thin : Material.ultraThin)
            }
    }
}

#Preview {
    Button(action: {
        
    }) {
        Text("Button")
    }
    .buttonStyle(NovelGameTitleButtonStyle())
}
