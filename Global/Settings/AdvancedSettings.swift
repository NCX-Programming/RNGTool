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
    @EnvironmentObject private var settingsData: SettingsData
    #if os(iOS)
    @State private var engine: CHHapticEngine?
    #endif
    @State private var showResetPrompt = false
    #if targetEnvironment(simulator)
    @State private var devCount = 3 // Always show the developer mode toggle if we're using a sim, no reason to hide it there
    #else
    @State private var devCount = 0
    #endif
    
    var body: some View {
        Form {
            #if os(macOS)
            Section(header: Text("Updates")) {
                Toggle("Check for updates on startup", isOn: $settingsData.checkUpdatesOnStartup)
            }
            #endif
            Section(header: Text("Save Mode States"), footer: Text("Whether or not the random numbers generated will be saved between launches.")) {
                Toggle("Save generator states", isOn: $settingsData.saveModeStates)
            }
            Section(header: Text("Settings Reset"),footer: Text("This will reset all of RNGTool's settings to their default values!")) {
                Button(action:{
                    #if os(iOS)
                    playHaptics(engine: engine, intensity: 0.8, sharpness: 0.5, count: 0.1)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.click)
                    #endif
                    devCount += 1
                    showResetPrompt = true
                }) {
                    Text("Reset Settings")
                }
                .alert("Confirm Reset", isPresented: $showResetPrompt, actions: {
                    Button("Confirm", role: .destructive) {
                        settingsData.maxNumberDefault = 100
                        settingsData.minNumberDefault = 0
                        resetGenSet(settingsData: settingsData)
                        resetDiceSet(settingsData: settingsData)
                        resetCardSet(settingsData: settingsData)
                        resetMarbleSet(settingsData: settingsData)
                        resetAdvSet(settingsData: settingsData)
                        showResetPrompt = false
                    }
                }, message: {
                    Text("Are you sure you want to reset all settings to their defaults? This cannot be undone.")
                })
            }
            #if DEBUG && !os(macOS)
            if(settingsData.showDevMode || devCount > 2) {
                Section(header: Text("Developer Mode"),footer: Text("Enable access to developer mode. This option will survive settings resets.")) {
                    Toggle("Show Developer Mode", isOn: $settingsData.showDevMode)
                }
            }
            #endif
        }
        #if !os(macOS)
        .navigationBarTitle("Advanced")
        .navigationBarTitleDisplayMode(.inline)
        #endif
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
