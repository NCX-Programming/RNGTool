//
//  SettingsData.swift
//  RNGTool
//
//  Created by Campbell on 12/19/21.
//

import Foundation
import SwiftUI

struct HistoryTable: Identifiable {
    var modeUsed: String
    var numbers: String
    let id = UUID()
}

class SettingsData : ObservableObject {
    // Variable to store the history of generated numbers
    @Published var historyTable = [HistoryTable]()
    // General Settings (Previously "Interface Settings")
    @AppStorage("confirmGenResets") var confirmGenResets: Bool = true
    @AppStorage("showModeHints") var showModeHints: Bool = true
    @AppStorage("playAnimations") var playAnimations: Bool = true
    @AppStorage("useMotionInput") var useMotionInput: Bool = true
    // Advanced Settings
    @AppStorage("saveModeStates") var saveModeStates: Bool = true
    @AppStorage("checkUpdatesOnStartup") var checkUpdatesOnStartup: Bool = true // macOS-only key
    @AppStorage("showDevMode") var showDevMode: Bool = false
    // Number Settings
    @AppStorage("maxNumberDefault") var maxNumberDefault: Int = 100
    @AppStorage("minNumberDefault") var minNumberDefault: Int = 0
    // Dice Settings (DEPRECATED)
    //@AppStorage("showDiceAnimation") var showDiceAnimation = true
    //@AppStorage("allowDiceImages") var allowDiceImages = true
    //@AppStorage("useShakeForDice") var useShakeForDice = true
    // Card Settings
    //@AppStorage("showCardAnimation") var showCardAnimation = true
    @AppStorage("showPoints") var showPoints: Bool = false
    @AppStorage("aceValue") var aceValue: Int = 1
    // Marble Settings (DEPRECATED)
    //@AppStorage("showMarbleAnimation") var showMarbleAnimation = true
    //@AppStorage("useShakeForMarbles") var useShakeForMarbles = true
    // Dummy @AppStorage key used for stubbed settings views
    @AppStorage("dummyKey") var dummyKey: Bool = false
}
