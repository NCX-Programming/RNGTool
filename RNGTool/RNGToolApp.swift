//
//  RNGToolApp.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

@main
struct RNGToolApp: App {
    @StateObject var settingsData: SettingsData = SettingsData()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(settingsData)
        }
        .commands {
            RNGToolCommands()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        WindowGroup("History") {
            History().environmentObject(settingsData)
        }.handlesExternalEvents(matching: Set(arrayLiteral: "History"))
        #endif
    }
}

#if os(macOS)
enum OpenWindows: String, CaseIterable {
    case History = "History"

    func open(){
        if let url = URL(string: "rngtool://\(self.rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
}
#endif
