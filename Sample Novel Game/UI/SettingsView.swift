//
//  SettingsView.swift
//  Novel Game Sample
//  
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//                    .listRowBackground (
//                       RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .background(Material.ultraThin)
//                    )
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .formStyle(.grouped)
            .navigationTitle("Settings")
        }
        .presentationBackground(Material.ultraThin)
        #if os(macOS)
        .frame(minWidth: 300, minHeight: 400)
        #endif
    }
}

#Preview {
    SettingsView()
}
