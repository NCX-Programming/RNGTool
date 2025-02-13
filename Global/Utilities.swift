//
//  Utilities.swift
//  RNGTool
//
//  Created by Campbell on 11/24/21.
//

import Foundation
#if os(iOS)
import UIKit
#endif
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

func resetGenSet(settingsData: SettingsData) {
    settingsData.confirmGenResets = true
    settingsData.showModeHints = true
    settingsData.playAnimations = true
    settingsData.useMotionInput = true
}

func resetDiceSet(settingsData: SettingsData) {
    // Dummy
    return
}

func resetCardSet(settingsData: SettingsData) {
    settingsData.showPoints = false
    settingsData.aceValue = 1
}

func resetMarbleSet(settingsData: SettingsData) {
    // Dummy
    return
}

func resetAdvSet(settingsData: SettingsData) {
    settingsData.saveModeStates = true
    #if os(macOS)
    settingsData.checkUpdatesOnStartup = true // macOS-only key
    #endif
}

#if os(iOS)
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
#endif
