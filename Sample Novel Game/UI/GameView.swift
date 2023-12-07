//
//  GameView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var novelColtoroler: NovelControler
    
    @State private var isShowingToolbar = true
    @State private var isOpeningSettings = false
    
    init(sceneList: Array<SceneInfo>) {
        self._novelColtoroler = State(initialValue: NovelControler(sceneList: sceneList))
        self.isShowingToolbar = true
        self.isOpeningSettings = false
        novelColtoroler.endAction = {
            print("end")
        }
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(novelColtoroler.background)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity)
                    .overlay {
                        GeometryReader{ geometry in
                            HStack {
                                ForEach(novelColtoroler.characters, id: \.self) { character in
                                    Image(character)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: geometry.size.height / 1.5)
                                        .padding(.horizontal)
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
                            
                            HStack {
                                
                                
                                VStack(alignment: .leading) {
                                    Text(novelColtoroler.talker)
                                        .font(.title2)
                                        .bold()
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 7.5, x: 3, y: 3)
                                    Text(novelColtoroler.quote)
                                        .font(.title3)
                                        .foregroundStyle(Color.white)
                                        .shadow(radius: 7.5, x: 3, y: 3)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal,200)
                                .padding(.vertical)
                                
                                
                            }
                            .frame(height: geometry.size.height / 4)
                            .frame(maxHeight: .infinity,alignment: .bottom)
                            .background {
                                LinearGradient(gradient: Gradient(colors: [.accentColor, .clear]), startPoint: .bottom, endPoint: .top)
                                    .frame(height: geometry.size.height / 4)
                                    .frame(maxHeight: .infinity,alignment: .bottom)
                            }
                        }
                        .frame(maxHeight: .infinity,alignment: .bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Image(novelColtoroler.background)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .blur(radius: 10.0)
                            .brightness(-0.15)
                #if os(visionOS)
                            .opacity(0.2)
                #endif
                    }
            }
            .onTapGesture {
                novelColtoroler.next()
            }
            .onLongPressGesture {
                if !isShowingToolbar {
                    isShowingToolbar = true
                }
            }
            .ignoresSafeArea()
#if !os(macOS)
            .toolbar(id: "notmacnovel") {
                ToolbarItem(id: "title", placement: .topBarLeading) {
                    Button(action: {
                            dismiss()
                    }){
                        Label("Back to Title", systemImage: "arrow.down.forward.and.arrow.up.backward")
                    }
                    .help("Back to Title")
                    .tint(Color.white.opacity(0.825))
                }
                
                ToolbarItem(id: "settings", placement: .topBarLeading) {
                    Button(action: {
                        isOpeningSettings.toggle()
                    }){
                        Label("Settings", systemImage: "gear")
                    }
                    .help("Settings")
                    .tint(Color.white.opacity(0.825))
                }
            }
            #else
            .toolbar(id: "macnovel") {
                ToolbarItem(id: "title", placement: .navigation) {
                    Button(action: {
                            dismiss()
                    }){
                        Label("Back to Title", systemImage: "arrow.down.forward.and.arrow.up.backward")
                    }
                    .help("Back to Title")
                    .tint(Color.white.opacity(0.825))
                }
                
                ToolbarItem(id: "settings", placement: .navigation) {
                    SettingsLink()
                        .help("Settings")
                        .tint(Color.white.opacity(0.825))
                }
            }
            #endif
            .toolbar(id: "novel") {
                if isShowingToolbar {
//#if !os(macOS)
//                    ToolbarItem(id: "settings", placement: .topBarLeading) {
//                        Button(action: {
//                            isOpeningSettings.toggle()
//                        }){
//                            Label("Settings", systemImage: "gear")
//                        }
//                        .help("Settings")
//                        .tint(Color.white.opacity(0.825))
//                    }
//#else
//                    ToolbarItem(id: "title", placement: .navigation) {
//                        Button(action: {
////                            dismiss()
//                        }){
//                            Label("Title", systemImage: "gear")
//                        }
//                        .help("Title")
//                        .tint(Color.white.opacity(0.825))
//                    }
//                    
//                    ToolbarItem(id: "settings", placement: .navigation) {
//                        SettingsLink()
//                            .help("Settings")
//                            .tint(Color.white.opacity(0.825))
//                    }
//#endif
//                    
                    ToolbarItem(id: "spacer", placement: .primaryAction) {
                        Spacer()
                    }
                    
                    ToolbarItem(id: "save", placement: .primaryAction) {
                        Button(action: {
                            
                        }) {
                            Label("Save", systemImage: "bookmark.fill")
                        }
                        .help("Save")
                        .tint(Color.white.opacity(0.825))
                    }
                    
                    ToolbarItem(id: "load", placement: .primaryAction) {
                        Button(action: {
                            
                        }) {
                            Label("Load", systemImage: "arrowshape.down.fill")
                        }
                        .help("Load")
                        .tint(Color.white.opacity(0.825))
                    }
                    
#if !os(visionOS)
                    ToolbarItem(id: "backward.frame", placement: .primaryAction) {
                        Button(action: {
                            novelColtoroler.first()
                        }) {
                            Label("Backward Frame", systemImage: "backward.frame.fill")
                        }
                        .help("Backward Frame")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotBack)
                    }
                    
                    ToolbarItem(id: "backward", placement: .primaryAction) {
                        Button(action: {
                            novelColtoroler.back()
                        }) {
                            Label("Backword", systemImage: "backward.fill")
                        }
                        .help("Backward")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotBack)
                    }
                    
                    ToolbarItem(id: "play_pause", placement: .primaryAction) {
                        Button(action: {
                            novelColtoroler.autoPlay()
                        }) {
                            Label(novelColtoroler.isAutoPlay ? "Pause" : "Play", systemImage: novelColtoroler.isAutoPlay ? "pause.fill" : "play.fill")
                        }
                        .help(novelColtoroler.isAutoPlay ? "Pause" : "Play")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                    }
                    
                    ToolbarItem(id: "forward", placement: .primaryAction) {
                        Button(action: {
                            novelColtoroler.next()
                        }) {
                            Label("Forward", systemImage: "forward.fill")
                        }
                        .help("Forward")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                        .keyboardShortcut(.space, modifiers: [])
                    }
                    
                    ToolbarItem(id: "forward.frame", placement: .primaryAction) {
                        Button(action: {
                            novelColtoroler.last()
                        }) {
                            Label("Forward Frame", systemImage: "forward.frame.fill")
                        }
                        .help("Forward Frame")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                    }
                    
                    ToolbarItem(id: "erase", placement: .primaryAction) {
                        Button(action: {
                            isShowingToolbar.toggle()
                        }) {
                            Label("Hide Toolbar", systemImage: "xmark")
                        }
                        .help("Hide Toolbar")
                        .tint(Color.white.opacity(0.825))
                    }
#else
                    ToolbarItem(id: "backward.frame", placement: .bottomOrnament) {
                        Button(action: {
                            novelColtoroler.first()
                        }) {
                            Label("Backward Frame", systemImage: "backward.frame.fill")
                        }
                        .help("Backward Frame")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotBack)
                    }
                    
                    ToolbarItem(id: "backward", placement: .bottomOrnament) {
                        Button(action: {
                            novelColtoroler.back()
                        }) {
                            Label("Backword", systemImage: "backward.fill")
                        }
                        .help("Backword")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotBack)
                    }
                    
                    ToolbarItem(id: "play", placement: .bottomOrnament) {
                        Button(action: {
                            novelColtoroler.autoPlay()
                        }) {
                            Label(novelColtoroler.isAutoPlay ? "Pause" : "Play", systemImage: novelColtoroler.isAutoPlay ? "pause.fill" : "play.fill")
                        }
                        .help(novelColtoroler.isAutoPlay ? "Pause" : "Play")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                    }
                    
                    ToolbarItem(id: "forward", placement: .bottomOrnament) {
                        Button(action: {
                            novelColtoroler.next()
                        }) {
                            Label("Forward", systemImage: "forward.fill")
                        }
                        .help("Forward")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                    }
                    
                    ToolbarItem(id: "forward.frame", placement: .bottomOrnament) {
                        Button(action: {
                            novelColtoroler.last()
                        }) {
                            Label("Forward Frame", systemImage: "forward.frame.fill")
                        }
                        .help("Forward Frame")
                        .tint(Color.white.opacity(0.825))
                        .disabled(novelColtoroler.canNotNext)
                    }
                    
                    ToolbarItem(id: "erase", placement: .bottomOrnament) {
                        Button(action: {
                            isShowingToolbar.toggle()
                        }) {
                            Label("Hide Toolbar", systemImage: "xmark")
                        }
                        .help("Hide Toolbar")
                        .tint(Color.white.opacity(0.825))
                    }
#endif
                }
            }
#if os(iOS)
            .toolbar {
                if isShowingToolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            
                        }) {
                            Label("Save", systemImage: "bookmark.fill")
                        }
                        .help("Save")
                        .tint(Color.white.opacity(0.825))
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            Label("Load", systemImage: "arrowshape.down.fill")
                                .foregroundStyle(Color("toolbarColor"))
                        }
                        .help("Load")
                        .tint(Color.white.opacity(0.825))
                    }
                }
            }
#endif
#if !os(macOS)
            .sheet(isPresented: $isOpeningSettings) {
                SettingsView()
            }
#endif
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            novelColtoroler.stopPlayAll()
        }
    }
}

#Preview {
    let sceneList = [
        SceneInfo(primaryBGM: "bgm1")
    ]
    return GameView(sceneList: sceneList)
}