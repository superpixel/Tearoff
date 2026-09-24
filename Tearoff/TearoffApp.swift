//
//  TearoffApp.swift
//  Tearoff
//
//  Created by Nico Rohrbach on 22.09.2026.
//

import SwiftUI

@main
struct TearoffApp: App {
    @State private var model = TearoffModel()
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        Window("Tearoff", id: "main") {
            ContentView()
                .environment(model)
                .frame(minWidth: 400, minHeight: 300)
        }
        .defaultPosition(.center)
        .defaultSize(width: 460, height: 320)
        .commands {
            CommandGroup(after: .newItem) {
                Button("Choose item…") {
                    model.isShowingFileImporter = true
                }
                .keyboardShortcut("o", modifiers: .command)
            }
            
            CommandGroup(after: .pasteboard) {
                Button {
                    model.reset()
                } label: {
                    Label("Remove", systemImage: "clear")
                }
                .keyboardShortcut(.delete, modifiers: [.command])
                .disabled(model.droppedURL == nil)
            }
            
//            CommandGroup(replacing: .help) { }
            CommandGroup(replacing: .help) {
                Button("Tearoff Help") {
                    openWindow(id: "help")
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    
        Window("Tearoff Help", id: "help") {
            HelpView()
                .frame(minWidth: 200, maxWidth: 600, minHeight: 200,  maxHeight: .infinity)
                .containerBackground(
                    Color.accent.mix(with: Color(nsColor: .windowBackgroundColor), by: 0.8), for: .window)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        .defaultSize(width: 380, height: 400)
        .restorationBehavior(.disabled)
        .commandsRemoved()
    }
}
