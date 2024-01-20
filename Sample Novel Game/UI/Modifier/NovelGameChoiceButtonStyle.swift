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
            .frame(width: 400)
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
    .buttonStyle(NovelGameChoiceButtonStyle())
}
