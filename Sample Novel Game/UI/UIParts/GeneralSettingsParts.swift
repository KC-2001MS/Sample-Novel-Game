//
//  GeneralSettingsParts.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/20.
//


import SwiftUI

struct GeneralSettingsParts: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(SettingsObject.self) var settings
    
    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            Form {
                Group {
                    Section {
                        Slider(value: $settings.talkerFontSize, in: 15.0...30.0) {
                            Text("Talker")
                        } minimumValueLabel: {
                            Image(systemName: "textformat.size.smaller")
                        } maximumValueLabel: {
                            Image(systemName: "textformat.size.larger")
                        }
                        
                        Slider(value: $settings.quoteFontSize, in: 7.5...20.0) {
                            Text("Quote")
                        } minimumValueLabel: {
                            Image(systemName: "textformat.size.smaller")
                        } maximumValueLabel: {
                            Image(systemName: "textformat.size.larger")
                        }
                    } header: {
                        Text("Font Size")
                    }
                    
                    Section {
                        Slider(value: $settings.voiceVolume, in: 0...1.0) {
                            Text("Voice")
                        } minimumValueLabel: {
                            Image(systemName: "speaker.wave.1")
                        } maximumValueLabel: {
                            Image(systemName: "speaker.wave.3")
                        }
                        
                        Slider(value: $settings.primaryBGMVolume, in: 0...1.0) {
                            Text("BGM")
                        } minimumValueLabel: {
                            Image(systemName: "speaker.wave.1")
                        } maximumValueLabel: {
                            Image(systemName: "speaker.wave.3")
                        }
                        
                        Slider(value: $settings.secondaryBGMVolume, in: 0...1.0) {
                            Text("Sound effect")
                        } minimumValueLabel: {
                            Image(systemName: "speaker.wave.1")
                        } maximumValueLabel: {
                            Image(systemName: "speaker.wave.3")
                        }
                    } header: {
                        Text("Volume")
                    }
                    
                    
                    
                    Section {
                        Stepper("Waiting Time: \(settings.waitingTime)", value: $settings.waitingTime, in: 1...10, step: 1)
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
            .navigationTitle("General")
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
    GeneralSettingsParts()
}
