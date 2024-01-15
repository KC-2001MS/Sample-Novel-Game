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

    var body: some View {
        NavigationStack {
            Group {
                if saveData.isEmpty {
                    ContentUnavailableView("No Save Data", image: "opticaldiscdrive")
                } else {
                    GeometryReader { geom in
                        ScrollView(.horizontal) {
                            LazyHGrid(
                                rows: Array(repeating: GridItem(.adaptive(minimum: .infinity, maximum: .infinity)), count: 3),
                                alignment: .center,
                                spacing: 0
                            ) {
                                ForEach(saveData, id: \.self) { item in
                                    VStack {
                                        Text(item.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                                        Text("\(item.screen.chapter) - \(item.screen.section)")
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Button {
                                                modelContext.delete(item)
                                            } label: {
                                                Image(systemName: "trash")
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                    .frame(width: (geom.size.width / 2) - 10, height: (geom.size.height / 3) - 10)
                                    .frame(maxHeight: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(Color.red)
                                    }
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
    }
}

#Preview {
    LoadDataView()
}
