//
//  HelpView.swift
//  Sample Novel Game
//  
//  Created by Keisuke Chinone on 2024/01/20.
//


import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading,spacing: 25) {
                    VStack(alignment: .leading,spacing: 5) {
                        Text("Sample Novel Game")
#if !os(watchOS) && !os(tvOS)
                            .font(.title)
#else
                            .font(.headline)
#endif
                            .bold()
#if !os(visionOS)
                            .foregroundStyle(Color.accentColor)
#endif
                        VStack(alignment: .leading,spacing: 5) {
                            Text("In this application you will enjoy a sample novel game.")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
#if os(visionOS)
                        .background(.regularMaterial, in: .rect(cornerRadius: 30))
#endif
                    }
                    .focusable(interactions: .activate)
                    
                    VStack(alignment: .leading,spacing: 5) {
                        Text("Report bugs")
#if !os(watchOS) && !os(tvOS)
                            .font(.title)
#else
                            .font(.headline)
#endif
                            .bold()
#if !os(visionOS)
                            .foregroundStyle(Color.accentColor)
#endif
                        VStack(alignment: .leading,spacing: 5) {
                            
                            Text("If you find any problems with this application, please report them via this URL or email.")
#if !os(watchOS) && !os(tvOS)
                            Link("Bug Report Page", destination: URL(string: NSLocalizedString("Bug Report URL", comment: "Bug Report Page")) ?? URL(string: NSLocalizedString("https://kc-2001ms.github.io/en/", comment: "Iroiro's Top Page"))!)
#endif
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
#if os(visionOS)
                        .background(.regularMaterial, in: .rect(cornerRadius: 30))
#endif
                    }
                    .focusable(interactions: .activate)
                    
                    VStack(alignment: .leading,spacing: 5) {
                        Text("Privacy Policy")
#if !os(watchOS) && !os(tvOS)
                            .font(.title)
#else
                            .font(.headline)
#endif
                            .bold()
#if !os(visionOS)
                            .foregroundStyle(Color.accentColor)
#endif
                        VStack(alignment: .leading,spacing: 5) {
                            
                            Text("You can review the privacy policy for this application at the following site")
                            
#if !os(watchOS) && !os(tvOS)
                            Link("Privacy Policy Page", destination: URL(string: NSLocalizedString("https://kc-2001ms.github.io/en/privacy.html", comment: "Iroiro's Top Page")) ?? URL(string: NSLocalizedString("https://kc-2001ms.github.io/en/", comment: "Iroiro's Top Page"))!)
#else
                            Text(verbatim:"https://kc-2001ms.github.io/")
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
#endif
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
#if os(visionOS)
                        .background(.regularMaterial, in: .rect(cornerRadius: 30))
#endif
                    }
                    .focusable(interactions: .activate)
                }
                .padding()
            }
#if os(iOS)
            .background(Color(.iOSBackground))
#endif
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            .navigationTitle("Help")
#if !os(macOS) && !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        dismiss()
                    }){
                        Text("Done")
                    }
#if !os(tvOS)
                    .keyboardShortcut(.defaultAction)
#endif
                }
            }
#endif
        }
        .navigationTitle("Help")
        .frame(minWidth: 500, minHeight: 300)
    }
}

#Preview {
    HelpView()
}
