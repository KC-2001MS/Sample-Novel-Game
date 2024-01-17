//
//  Commands.swift
//  Novel Game Sample
//
//  Created by Keisuke Chinone on 2023/12/06.
//


import Foundation
import SwiftUI

struct BasicCommands: Commands {
    @Environment(\.openWindow) private var openWindow
    
    @FocusedValue(\.saveAction) var saveAction
    @FocusedValue(\.loadAction) var loadAction
    @FocusedValue(\.goTitleAction) var goTitleAction
    
    var body: some Commands {
#if os(macOS)
        CommandGroup(replacing: .help) {
            Link("Open the Web Site", destination: URL(string: "https://example.com")!)
            
            Button(action: {
                openWindow(id: "help")
            }) {
                Text("Novel Game Sample Help")
            }
            .keyboardShortcut("H", modifiers: [.command, .shift])
        }
#endif
        CommandGroup(after: .importExport) {
            Button(action: {
                saveAction?()
            }) {
                Text("Save")
            }
            .disabled(saveAction == nil)
            
            Button(action: {
                loadAction?()
            }) {
                Text("Load")
            }
            .disabled(loadAction == nil)
            
            Divider()
            
            Button(action: {
                goTitleAction?()
            }) {
                Text("Back to Title")
            }
            .disabled(goTitleAction == nil)
        }
        
        CommandMenu("Progression") {
//            Button(action: {
//                
//            }) {
//                Text("Back Log")
//            }
            
            Button(action: {
                
            }) {
                Text("Back Skip")
            }
            
            Button(action: {
                
            }) {
                Text("Play")
            }
            
            Button(action: {
                
            }) {
                Text("Skip")
            }
//            
//            Divider()
//            
//            Button(action: {
//                
//            }) {
//                Text("Proceed to the next choice")
//            }
//            
//            Button(action: {
//                
//            }) {
//                Text("Return to the previous choice")
//            }
//            
//            Button(action: {
//                
//            }) {
//                Text("Continue to next scene")
//            }
//            
//            Button(action: {
//                
//            }) {
//                Text("Return to previous scene")
//            }
//            
//            Divider()
//            
//            Button(action: {
//                
//            }) {
//                Text("Flow Chart")
//            }
        }
        
        CommandMenu("Letter") {
            Menu("Display Speed") {
                Button(action: {
                    
                }) {
                    Text("test")
                }
            }
            
            Menu("Fade") {
                Button(action: {
                    
                }) {
                    Text("test")
                }
            }
            
            Menu("Waiting Time") {
                Button(action: {
                    
                }) {
                    Text("test")
                }
            }
        }
    }
}
