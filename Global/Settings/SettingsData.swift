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
    // Advanced Settings
    @AppStorage("confirmGenResets") var confirmGenResets = true
    @AppStorage("showModeHints") var showModeHints = true
    @AppStorage("checkUpdatesOnStartup") var checkUpdatesOnStartup = true
    @AppStorage("showDevMode") var showDevMode = false
    // Number Settings
    @AppStorage("maxNumberDefault") var maxNumberDefault = 100
    @AppStorage("minNumberDefault") var minNumberDefault = 0
    // Dice Settings
    @AppStorage("showDiceAnimation") var showDiceAnimation = true
    @AppStorage("allowDiceImages") var allowDiceImages = true
    // Card Settings
    @AppStorage("showCardAnimation") var showCardAnimation = true
    @AppStorage("showPoints") var showPoints = false
    @AppStorage("aceValue") var aceValue = 1
    // Marble Settings
    @AppStorage("showMarbleAnimation") var showMarbleAnimation = true
}
