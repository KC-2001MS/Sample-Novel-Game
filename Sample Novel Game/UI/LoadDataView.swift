//
//  LoadDataView.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/13.
//


import SwiftUI
import SwiftData

struct LoadDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var saveData: Array<SaveData>
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var novelColtoroler: NovelSceneControler
    
#if os(macOS)
    let gridRows: Array<GridItem> = Array(repeating: GridItem(.adaptive(minimum: .infinity, maximum: .infinity)), count: 3)
#else
    let gridRows: Array<GridItem> = Array(repeating: GridItem(.adaptive(minimum: .infinity, maximum: .infinity)), count: 2)
#endif
    
    var body: some View {
        NavigationStack {
            Group {
                if saveData.isEmpty {
                    ContentUnavailableView("No Save Data", systemImage: "opticaldiscdrive")
                } else {
                    GeometryReader { geom in
                        ScrollView(.horizontal) {
                            LazyHGrid(
                                rows: gridRows,
                                alignment: .center,
                                spacing: 0
                            ) {
                                ForEach(saveData, id: \.self) { saveData in
                                    SaveDataCard(saveData: saveData,novelColtoroler: novelColtoroler,dismissAction: {
                                        dismiss()
                                    })
                                    .frame(width: (geom.size.width / 2) - 10, height: (geom.size.height / Double(gridRows.count)) - 10)
                                }
                                .padding(.horizontal,5)
                            }
                            .padding(.vertical,5)
                            .scrollTargetLayout()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scrollTargetBehavior(.paging)
                    }
                }
            }
            .toolbar(id: "loading") {
                ToolbarItem(id: "done", placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
#if !os(iOS)
        .frame(width: 600, height: 600)
#endif
        .preferredColorScheme(.dark)
    }
}

#Preview {
    @State var novelColtoroler = NovelSceneControler(scenes: Bundle.main.decodeJSON("game.json"), id: NovelID())
    return LoadDataView(novelColtoroler: novelColtoroler)
}
