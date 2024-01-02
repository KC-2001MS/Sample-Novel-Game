//
//  SettingsView.swift
//  Novel Game Sample
//  
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
#if !os(visionOS)
                .listRowBackground(Color.clear)
#endif
            }
            .formStyle(.grouped)
#if !os(visionOS)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
#endif
            .navigationTitle("Settings")
#if !os(macOS)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
#endif
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
