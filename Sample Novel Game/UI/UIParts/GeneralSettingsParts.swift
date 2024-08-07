//
//  GeneralSettingsParts.swift
//  Sample Novel Game
//
//  Created by Keisuke Chinone on 2024/01/20.
//


import SwiftUI
import SwiftData
import OSLog

struct GeneralSettingsParts: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(SettingsObject.self) var settings
    
    @Query(sort: \SaveData.date, order: .reverse) private var saveData: Array<SaveData>
    
    @State var isExporting = false
    @State var isImporting = false
    
    @State private var document: JsonFile?
    
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
                    
                    Section {
                        Button {
                            self.isImporting.toggle()
                        } label: {
                            Text("Import")
                        }
                        
                        Button {
                            self.document = JsonFile(initialText: settings.ExportAppData(data: saveData))
                            
                            self.isExporting.toggle()
                        } label: {
                            Text("Export")
                        }
                    } header: {
                        Text("Save Data")
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
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: .json,
            defaultFilename: "Sample Novel Game Save Data",
            onCompletion: { (result) in
                switch result {
                case .success(let url):
                    Logger.app.log("Saved In: \(url)")
                case .failure(let error):
                    Logger.app.error("\(error.localizedDescription)")
                }
            }
        )
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let url):
                let data = settings.importAppData(url: url[0])
                for datum in data {
                    modelContext.insert(datum)
                }
                try? modelContext.save()
            case .failure:
                print("failure")
            }
        }
    }
}

#Preview {
    GeneralSettingsParts()
}
