//
//  RNGToolCommands.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct RNGToolCommands: Commands {
    
    
    var body: some Commands {
        SidebarCommands()
        #if os(macOS)
        CommandGroup(after: CommandGroupPlacement.appInfo) {
            UpdateCheck()
        }
        CommandGroup(before: CommandGroupPlacement.sidebar) {
            Button("Show History") {
                OpenWindows.History.open()
            }
            .keyboardShortcut("h", modifiers: [.command, .shift])
            Divider()
        }
        #endif
    }
}
