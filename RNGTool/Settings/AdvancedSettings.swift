//
//  AdvancedSettings.swift
//  RNGTool
//
//  Created by Campbell on 10/14/21.
//

import SwiftUI

struct AdvancedSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    @State private var showAlert = false
    @State private var devCount = 0
    
    var body: some View {
        Toggle("Ask to confirm resetting the generator", isOn: $settingsData.confirmGenResets)
        Text("Disabling this will allow you to reset the generator without having to confirm it first.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        Button(action:{
            showAlert = true
        }) {
            Text("Reset Settings")
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Confirm Reset"),
                message: Text("Are you sure you want to reset all settings to their defaults? This cannot be undone."),
                primaryButton: .default(Text("Confirm")){
                    resetNumSet()
                    resetDiceSet()
                    resetCardSet()
                    resetMarbleSet()
                    settingsData.confirmGenResets = true
                    showAlert = false
                },
                secondaryButton: .cancel()
            )
        }
        Text("This will reset all of RNGTool's settings to their default values!")
            .font(.subheadline)
            .foregroundColor(.secondary)
        #if os(iOS)
            .onTapGesture {
                devCount += 1
            }
        #endif
        if(settingsData.showDevMode || devCount > 4) {
            Toggle("Show Developer Mode", isOn: $settingsData.showDevMode)
            Text("Enable access to developer mode. Disabling this will re-hide the toggle.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct AdvancedSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettings().environmentObject(SettingsData())
    }
}
