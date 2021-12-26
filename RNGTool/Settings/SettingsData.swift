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
    var numbers: Int
    let id = UUID()
}

class SettingsData : ObservableObject {
    // Variable to store the
    @Published var historyTable = [HistoryTable]()
    // Advanced Settings
    @AppStorage("confirmGenResets") var confirmGenResets = true
    // Number Settings
    @AppStorage("maxNumberDefault") var maxNumberDefault = 100
    @AppStorage("minNumberDefault") var minNumberDefault = 0
    // Dice Settings
    @AppStorage("forceSixSides") var forceSixSides = false
    @AppStorage("allowDiceImages") var allowDiceImages = true
    // Card Settings
    @AppStorage("showPoints") var showPoints = false
    @AppStorage("aceValue") var aceValue = 1
    @AppStorage("useFaces") var useFaces = true
    // Marble Settings
    @AppStorage("showLetterList") var showLetterList = false

}
