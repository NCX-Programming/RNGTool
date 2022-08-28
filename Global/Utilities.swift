//
//  Utilities.swift
//  RNGTool
//
//  Created by Campbell on 11/24/21.
//

import Foundation
import SwiftUI

let removeCharacters: Set<Character> = ["[", "]", "\""]

func addHistoryEntry(settingsData: SettingsData, results: String, mode: String) {
    var resultsClear: String = results
    resultsClear.removeAll(where: { removeCharacters.contains($0) } )
    if(settingsData.historyTable.count == 50) { settingsData.historyTable.remove(at: 0) }
    settingsData.historyTable.append(HistoryTable(modeUsed: mode, numbers: resultsClear))
}

func copyToClipboard(item: String) {
    #if os(macOS)
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(item, forType: NSPasteboard.PasteboardType.string)
    var clipboardItems: [String] = []
    for element in pasteboard.pasteboardItems! {
        if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
            clipboardItems.append(str)
        }
    }
    #elseif os(iOS)
    UIPasteboard.general.string = "\(item)"
    #endif
}

func resetDiceSet() {
    @AppStorage("allowDiceImages") var allowDiceImages = true
    @AppStorage("showDiceAnimation") var showDiceAnimation = true
    
    allowDiceImages = true
    showDiceAnimation = true
}

func resetCardSet() {
    @AppStorage("showPoints") var showPoints = false
    @AppStorage("aceValue") var aceValue = 1
    @AppStorage("showCardAnimation") var showCardAnimation = true
    
    showPoints = false
    aceValue = 1
    showCardAnimation = true
}

func resetMarbleSet() {
    @AppStorage("showMarbleAnimation") var showMarbleAnimation = true
    
    showMarbleAnimation = true
}
