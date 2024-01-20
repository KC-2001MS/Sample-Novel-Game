//
//  DialogSettingsParts.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/20.
//


import SwiftUI

struct DialogSettingsParts: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(SettingsObject.self) var settings
    
    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            Form {
                Group {
                    Section {
                        Toggle("Check at the time of loading.", isOn: $settings.isDisplayingDialogWhenLoading)
                        Toggle("Check when returning to the title.", isOn: $settings.isDisplayingDialogWhenGoingBack)
                    }
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
            .navigationTitle("Dialog")
#if !os(macOS)
            .toolbarBackground(Material.ultraThin,for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
#if !os(visionOS)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 7.5)
                            .padding(.vertical, 5)
                            .background {
                                Capsule()
                                    .foregroundStyle(Color.accentColor)
                            }
#endif
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
#else
            .toolbarBackground(Material.ultraThin,for: .windowToolbar)
#endif
        }
        .presentationBackground(Material.ultraThin)
        .focusedSceneValue(\.waitingTime, $settings.waitingTime)
    }
}

#Preview {
    DialogSettingsParts()
}
