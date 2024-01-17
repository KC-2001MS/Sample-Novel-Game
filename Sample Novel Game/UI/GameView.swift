//
//  GameView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var saveData: Array<SaveData>
    
    @Environment(SettingsObject.self) var settings
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion
    
    @State private var novelColtoroler: NovelSceneControler
    
    @State private var isShowingToolbar = true
    @State private var isOpeningSettings = false
    @State private var isOpeningLoading = false
    
    @State private var isAlert = false
    
    @State var timer: Timer?
    
    init(scenes: Array<NovelScene>, id: NovelID) {
        self._novelColtoroler = State(initialValue: NovelSceneControler(scenes: scenes, id: id))
        self.isShowingToolbar = true
        self.isOpeningSettings = false
        novelColtoroler.endAction = {
            print("end")
        }
    }
    
    var body: some View {
        NavigationStack {
            Image(novelColtoroler.background)
                .resizable()
                .frame(maxHeight: .infinity)
                .aspectRatio(contentMode: .fit)
                .overlay {
                    GeometryReader{ geometry in
                        HStack {
                            ForEach(novelColtoroler.characters, id: \.self) { character in
                                Image(character)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: geometry.size.height)
                                    .padding(.horizontal)
                                    .padding(.top, geometry.size.height/3)
                            }
                        }
                        .keyframeAnimator(initialValue: KeyFrame(),trigger: novelColtoroler.characters) { content, value in
                            if accessibilityReduceMotion {
                                content
                            } else {
                                content
                                    .opacity(value.opacity)
                            }
                        } keyframes: { frame in
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(1.0, duration: 0.5)
                            }
                        }
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(novelColtoroler.talker)
                                    .font(.custom("", size: CGFloat(settings.talkerFontSize), relativeTo: .title2))
                                    .bold()
                                    .foregroundStyle(Color.white)
                                    .shadow(radius: 7.5, x: 3, y: 3)
                                Text(novelColtoroler.quote)
                                    .font(.custom("", size: CGFloat(settings.quoteFontSize), relativeTo: .body))
                                    .foregroundStyle(Color.white)
                                    .shadow(radius: 7.5, x: 3, y: 3)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal,geometry.size.width / 10)
                            .padding(.vertical)
                            
                            if novelColtoroler.isAutoPlay && novelColtoroler.choices == nil {
                                Gauge(value: novelColtoroler.autoplayTime, in: 0...novelColtoroler.time) {
                                    Text(String(format: "%.1f", novelColtoroler.autoplayTime))
                                }
                                .gaugeStyle(.accessoryCircularCapacity)
                                .scaleEffect(0.6)
                                .padding()
                            }
                        }
                        .frame(height: geometry.size.height / 4)
                        .frame(maxHeight: .infinity,alignment: .bottom)
                        .background {
                            LinearGradient(gradient: Gradient(colors: [.accentColor, .clear]), startPoint: .bottom, endPoint: .top)
                                .frame(height: geometry.size.height / 4)
                                .frame(maxHeight: .infinity,alignment: .bottom)
                        }
                        
                        HStack {
                            Text(novelColtoroler.id?.chapterAndSection ?? "")
                                .font(.title3)
                                .foregroundStyle(Color.white)
                                .bold()
                                .frame(width: 100, height: 20, alignment: .center)
                                .padding(5)
                                .background {
                                    Capsule()
                                        .foregroundStyle(Color.accentColor)
                                }
                                .padding(.horizontal,5)
                                .keyframeAnimator(initialValue: KeyFrame(),trigger: novelColtoroler.id) { content, value in
                                    if accessibilityReduceMotion {
                                        content
                                    } else {
                                        content
                                            .opacity(value.opacity)
                                    }
                                } keyframes: { frame in
                                    KeyframeTrack(\.opacity) {
                                        LinearKeyframe(1.0, duration: 0.5)
                                        LinearKeyframe(1.0, duration: 1.5)
                                        LinearKeyframe(0.0, duration: 0.5)
                                    }
                                }
                            
                            Spacer()
                            
                            Label(novelColtoroler.BGMName, systemImage: "music.note")
                                .font(.callout)
                                .foregroundStyle(Color.white)
                                .frame(height: 20,alignment: .center)
                                .padding(5)
                                .background {
                                    Capsule()
                                        .foregroundStyle(Material.ultraThin)
                                }
                                .padding(.horizontal,5)
                                .keyframeAnimator(initialValue: KeyFrame(),trigger: novelColtoroler.BGMName) { content, value in
                                    if accessibilityReduceMotion {
                                        content
                                    } else {
                                        content
                                            .opacity(value.opacity)
                                    }
                                } keyframes: { frame in
                                    KeyframeTrack(\.opacity) {
                                        LinearKeyframe(1.0, duration: 0.5)
                                        LinearKeyframe(1.0, duration: 1.5)
                                        LinearKeyframe(0.0, duration: 0.5)
                                    }
                                }
                        }
                        .padding(.vertical, 35)
                        .frame(maxHeight: .infinity,alignment: .top)
                        
                        VStack {
                            if let choices = novelColtoroler.choices {
                                ForEach(choices) { choice in
                                    Button {
                                        novelColtoroler.choice(choice: choice)
                                    } label: {
                                        Text(choice.word)
                                    }
                                    .buttonStyle(NovelGameChoiceButtonStyle())
                                }
                            }
                        }
                        .padding(100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .frame(maxHeight: .infinity,alignment: .bottom)
                }
                .clipShape(Rectangle())
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
                    if isShowingToolbar {
                        ToolbarItem(id: "title", placement: .topBarLeading) {
                            Button(action: {
                                isAlert.toggle()
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
                }
#else
                .toolbar(id: "macnovel") {
                    if isShowingToolbar {
                        ToolbarItem(id: "title", placement: .navigation) {
                            Button(action: {
                                isAlert.toggle()
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
                }
#endif
                .toolbar(id: "novel") {
                    if isShowingToolbar {
                        ToolbarItem(id: "spacer", placement: .primaryAction) {
                            Spacer()
                        }
#if os(iOS)
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            ToolbarItem(id: "save", placement: .primaryAction) {
                                Button(action: {
                                    if let novelID = novelColtoroler.id {
                                        modelContext.insert(SaveData(screen: novelID))
                                    }
                                    try? modelContext.save()
                                }) {
                                    Label("Save", systemImage: "bookmark")
                                        .symbolVariant(saveData.filter{ return novelColtoroler.id == $0.screen && novelColtoroler.id?.number == $0.screen.number }.isEmpty ? .none : .fill)
                                }
                                .help("Save")
                                .tint(Color.white.opacity(0.825))
                            }
                            
                            ToolbarItem(id: "load", placement: .primaryAction) {
                                Button(action: {
                                    isOpeningLoading.toggle()
                                }) {
                                    Label("Load", systemImage: "arrowshape.down.fill")
                                }
                                .help("Load")
                                .tint(Color.white.opacity(0.825))
                            }
                        }
#else
                        ToolbarItem(id: "save", placement: .primaryAction) {
                            Button(action: {
                                if let novelID = novelColtoroler.id {
                                    modelContext.insert(SaveData(screen: novelID))
                                }
                                try? modelContext.save()
                            }) {
                                Label("Save", systemImage: "bookmark.fill")
                            }
                            .help("Save")
                            .tint(Color.white.opacity(0.825))
                        }
                        
                        ToolbarItem(id: "load", placement: .primaryAction) {
                            Button(action: {
                                isOpeningLoading.toggle()
                            }) {
                                Label("Load", systemImage: "arrowshape.down.fill")
                            }
                            .help("Load")
                            .tint(Color.white.opacity(0.825))
                        }
#endif
                        
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
                    if isShowingToolbar && UIDevice.current.userInterfaceIdiom == .phone {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button(action: {
                                if let novelID = novelColtoroler.id {
                                    modelContext.insert(SaveData(screen: novelID))
                                }
                                try? modelContext.save()
                            }) {
                                Label("Save", systemImage: "bookmark.fill")
                            }
                            .help("Save")
                            .tint(Color.white.opacity(0.825))
                            
                            Spacer()
                            
                            Button(action: {
                                isOpeningLoading.toggle()
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
                .sheet(isPresented: $isOpeningLoading) {
                    LoadDataView(novelColtoroler: novelColtoroler)
                }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            novelColtoroler.startPlayAll(waitingTime: settings.waitingTime)
        }
        .onChange(of: novelColtoroler.id?.number, initial: true) {
            Task {
                if !novelColtoroler.canNotNext && novelColtoroler.isAutoPlay {
                    timer?.invalidate()
                    novelColtoroler.autoplayTime = 0
                    self.timer = Timer.scheduledTimer(withTimeInterval:0.1, repeats: true){ _ in
                        novelColtoroler.autoplayTime += 0.1
                        print("now time:\(novelColtoroler.autoplayTime)")
                    }
                    _ = try await Task.sleep(for: .seconds(Double(novelColtoroler.time)))
                    timer?.invalidate()
                    novelColtoroler.next()
                    timer = nil
                    print("time: reset")
                }
            }
        }
        .onDisappear {
            if let novelID = novelColtoroler.id {
                modelContext.insert(SaveData(screen: novelID))
            }
            try? modelContext.save()
            novelColtoroler.stopPlayAll()
        }
        .alert("Shall we return to the title?", isPresented: $isAlert) {
            Button("Go to the title", role: .destructive) {
                dismiss()
                novelColtoroler.stopPlayAll()
            }
        }
        .focusedSceneValue(\.saveAction) {
            if let novelID = novelColtoroler.id {
                modelContext.insert(SaveData(screen: novelID))
            }
            try? modelContext.save()
        }
        .focusedSceneValue(\.loadAction) {
            isOpeningLoading.toggle()
        }
        .focusedSceneValue(\.goTitleAction) {
            isAlert.toggle()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let previewScenes: Array<NovelScene> = Bundle.main.decodeJSON("game.json")
    return GameView(scenes: previewScenes, id: NovelID())
}
