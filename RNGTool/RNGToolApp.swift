//
//  RNGToolApp.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

@main
struct RNGToolApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            RNGToolCommands()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
