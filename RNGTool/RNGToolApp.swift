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
        WindowGroup("History") {
            History()
        }.handlesExternalEvents(matching: Set(arrayLiteral: "History"))
        #endif
    }
}

#if os(macOS)
enum OpenWindows: String, CaseIterable {
    case History = "History"

    func open(){
        if let url = URL(string: "rngtool://\(self.rawValue)") { //replace myapp with your app's name
            NSWorkspace.shared.open(url)
        }
    }
}
#endif
