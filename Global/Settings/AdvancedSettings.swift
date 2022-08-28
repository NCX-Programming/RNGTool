//
//  AdvancedSettings.swift
//  RNGTool
//
//  Created by Campbell on 10/14/21.
//

import SwiftUI
#if os(iOS)
import CoreHaptics
#elseif os(watchOS)
import WatchKit
#endif

struct AdvancedSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    #if os(iOS)
    @State private var engine: CHHapticEngine?
    #endif
    @State private var showAlert = false
    @State private var devCount = 0
    
    var body: some View {
        Group {
            Section(header: Text("Interface"), footer: Text("Disable tap hints to hide text like \"Tap to roll\".")) {
                Toggle("Ask to confirm resets", isOn: $settingsData.confirmGenResets)
                Toggle("Show tap hints", isOn: $settingsData.showModeHints)
            }
            #if os(macOS)
            Section(header: Text("Updates")) {
                Toggle("Check for updates on startup", isOn: $settingsData.checkUpdatesOnStartup)
            }
            #endif
            Section(header: Text("Settings Reset"),footer: Text("This will reset all of RNGTool's settings to their default values!")) {
                Button(action:{
                    #if os(iOS)
                    devCount += 1
                    playHaptics(engine: engine, intensity: 0.8, sharpness: 0.5, count: 0.1)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.click)
                    #endif
                    showAlert = true
                }) {
                    Text("Reset Settings")
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text("Confirm Reset"),
                        message: Text("Are you sure you want to reset all settings to their defaults? This cannot be undone."),
                        primaryButton: .default(Text("Confirm")){
                            settingsData.maxNumberDefault = 100
                            settingsData.minNumberDefault = 0
                            resetDiceSet()
                            resetCardSet()
                            resetMarbleSet()
                            settingsData.confirmGenResets = true
                            settingsData.showModeHints = true
                            showAlert = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            if(settingsData.showDevMode || devCount > 2) {
                Section(header: Text("Developer Mode"),footer: Text("Enable access to developer mode. Disabling this will re-hide the toggle.")) {
                    Toggle("Show Developer Mode", isOn: $settingsData.showDevMode)
                }
            }
        }
        #if os(iOS)
        .onAppear { prepareHaptics(engine: &engine) }
        #endif
    }
}

struct AdvancedSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettings().environmentObject(SettingsData())
    }
}
