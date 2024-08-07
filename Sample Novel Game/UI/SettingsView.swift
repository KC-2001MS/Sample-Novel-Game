//
//  SettingsView.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(SettingsObject.self) var settings
    
    private enum Tabs:String, Hashable, CaseIterable {
        case general = "General"
        case dialog = "Dialog"
    }
    
    var body: some View {
        TabView {
            //基本設定
            GeneralSettingsParts()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .tag(Tabs.general)
                .accessibilityInputLabels(["General", "Gear"])
            //詳細設定
            DialogSettingsParts()
                .tabItem {
                    Label("Dialog", systemImage: "rectangle.badge.checkmark")
                }
                .tag(Tabs.dialog)
                .accessibilityInputLabels(["Dialog", "Rectangle"])
        }
#if  os(visionOS)
        .frame(minWidth: 500, minHeight: 700)
#elseif os(macOS)
        .frame(width: 500)
#endif
        .preferredColorScheme(.dark)
        .containerBackground(.thickMaterial, for: .window)
        .presentationSizing(.form)
    }
}

#Preview {
    @Previewable @State var settings = SettingsObject()
    
    return SettingsView().environment(settings)
}
