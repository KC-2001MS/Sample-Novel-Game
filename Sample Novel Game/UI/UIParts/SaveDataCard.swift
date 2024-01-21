//
//  SaveDataCard.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/17.
//


import SwiftUI
import SwiftData

struct SaveDataCard: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(SettingsObject.self) var settings
    
    @State private var isShowingDialog = false
    @State private var isSuppressed = false
    
    let saveData: SaveData
    @Bindable var novelColtoroler: NovelSceneControler
    
    let dismissAction: () -> ()
    
    
    var body: some View {
        @Bindable var settings = settings
        VStack {
            HStack {
                Text(saveData.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                Text("\(saveData.screen.chapter) - \(saveData.screen.section)")
                    .foregroundStyle(Color.white)
                    .bold()
            }
            .padding(5)
            .padding(.horizontal, 10)
            .background(Material.ultraThin)
            
            
            Spacer()
            
            HStack {
                Button {
                    isShowingDialog.toggle()
                } label: {
                    Image(systemName: "restart")
                }
                .buttonStyle(.borderless)
                .confirmationDialog(
                    "Do you want to load data?",
                    isPresented: $isShowingDialog
                ) {
                    Button("Load") {
                        novelColtoroler.change(id: saveData.screen)
                        dismissAction()
                    }
                    Button("Cancel", role: .cancel) {
                        isShowingDialog = false
                    }
                }
                .dialogSuppressionToggle(
                    "Don't ask again",
                    isSuppressed: $settings.isDisplayingDialogWhenLoading
                )
                
                
                Spacer()
                
                Button {
                    modelContext.delete(saveData)
                    try? modelContext.save()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(.borderless)
            }
            .padding(5)
            .padding(.horizontal, 10)
            .background(Material.ultraThin)
        }
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    @State var novelColtoroler = NovelSceneControler(scenes: Bundle.main.decodeJSON("game.json"), id: NovelID())
    return SaveDataCard(saveData: SaveData(date: Date(), screen: NovelID()), novelColtoroler: novelColtoroler, dismissAction: {})
}
