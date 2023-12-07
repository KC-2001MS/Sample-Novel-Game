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
                
            }) {
                Text("Save")
            }
            
            Button(action: {
                
            }) {
                Text("Load")
            }
            
            Button(action: {
                
            }) {
                Text("Quick Save")
            }
            
            Button(action: {
                
            }) {
                Text("Quick Load")
            }
            
            Divider()
            
            Button(action: {
                
            }) {
                Text("Back to Title")
            }
        }
        
        CommandMenu("Progression") {
            Button(action: {
                
            }) {
                Text("Back Log")
            }
            
            Button(action: {
                
            }) {
                Text("Auto")
            }
            
            Button(action: {
                
            }) {
                Text("Skip")
            }
            
            Button(action: {
                
            }) {
                Text("Back Skip")
            }
            
            Divider()
            
            Button(action: {
                
            }) {
                Text("Proceed to the next choice")
            }
            
            Button(action: {
                
            }) {
                Text("Return to the previous choice")
            }
            
            Button(action: {
                
            }) {
                Text("Continue to next scene")
            }
            
            Button(action: {
                
            }) {
                Text("Return to previous scene")
            }
            
            Divider()
            
            Button(action: {
                
            }) {
                Text("Options")
            }
            
            Button(action: {
                
            }) {
                Text("Flow Chart")
            }
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
