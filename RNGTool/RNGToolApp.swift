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
        #if !os(watchOS)
        .commands {
            RNGToolCommands()
        }
        #endif
        #if os(macOS)
        Settings {
            SettingsView().environmentObject(settingsData)
        }
        WindowGroup("History") {
            History().environmentObject(settingsData)
                .frame(width: 400, height: 200)
                .frame(maxWidth: 400, maxHeight: 200)
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
