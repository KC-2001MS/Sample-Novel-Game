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
    @FocusedValue(\.backwardAction) var backwardAction
    @FocusedValue(\.autoPlayAction) var autoPlayAction
    @FocusedValue(\.forwardAction) var forwardAction
    @FocusedBinding(\.waitingTime) var waitingTime
    @FocusedValue(\.helpAction) var helpAction
    
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Link("Open the Web Site", destination: URL(string: "https://example.com")!)
            
            Button(action: {
#if os(macOS)
                openWindow(id: "help")
#else
                helpAction?()
#endif
            }) {
                Text("Novel Game Sample Help")
            }
            .keyboardShortcut("H", modifiers: [.command, .shift])
        }
        
        CommandGroup(after: .importExport) {
            Button(action: {
                saveAction?()
            }) {
                Text("Save")
            }
            .disabled(saveAction == nil)
            .keyboardShortcut("S", modifiers: .command)
            
            Button(action: {
                loadAction?()
            }) {
                Text("Load")
            }
            .disabled(loadAction == nil)
            .keyboardShortcut("L", modifiers: .command)
            
            Divider()
            
            Button(action: {
                goTitleAction?()
            }) {
                Text("Back to Title")
            }
            .disabled(goTitleAction == nil)
            .keyboardShortcut("T", modifiers: .command)
        }
        
        CommandMenu("Progression") {
            //            Button(action: {
            //
            //            }) {
            //                Text("Back Log")
            //            }
            
            Button(action: {
                backwardAction?()
            }) {
                Text("Backward")
            }
            .disabled(backwardAction == nil)
            .keyboardShortcut(",", modifiers: .command)
            
            
            Button(action: {
                autoPlayAction?()
            }) {
                Text("Auto Play")
            }
            .disabled(autoPlayAction == nil)
            .keyboardShortcut("A", modifiers: .command)
            
            Button(action: {
                forwardAction?()
            }) {
                Text("Forward")
            }
            .disabled(forwardAction == nil)
            .keyboardShortcut(".", modifiers: .command)
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
            //            Menu("Display Speed") {
            //                Button(action: {
            //
            //                }) {
            //                    Text("Display Speed")
            //                }
            //            }
            //
            //            Menu("Fade") {
            //                Button(action: {
            //
            //                }) {
            //                    Text("Fade")
            //                }
            //            }
            
            Menu("Waiting Time") {
                Button(action: {
                    waitingTime = waitingTime! + 1
                }) {
                    Text("Add 1 second")
                }
                .disabled(waitingTime == nil || waitingTime! >= 10)
                .keyboardShortcut("+", modifiers: [.command])
                
                Button(action: {
                    waitingTime = waitingTime! - 1
                }) {
                    Text("Reduce 1 second")
                }
                .disabled(waitingTime == nil || waitingTime! <= 1)
                .keyboardShortcut("-", modifiers: [.command])
            }
        }
    }
}
