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
            Button("Check for Updates...") {
                OpenWindows.Update.open()
            }
        }
        #endif
    }
}
