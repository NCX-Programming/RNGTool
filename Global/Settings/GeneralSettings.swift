//
//  GeneralSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/2/22.
//

import SwiftUI

struct GeneralSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        Section(header: Text("General"), footer: Text("Disable usage hints to hide text like \"Tap to roll\".")) {
            Toggle("Ask to confirm resets", isOn: $settingsData.confirmGenResets)
            Toggle("Play animations", isOn: $settingsData.playAnimations)
            #if os(iOS)
            Toggle("Use gestures", isOn: $settingsData.useMotionInput)
            #endif
            Toggle("Show usage hints", isOn: $settingsData.showModeHints)
        }
    }
}

struct InterfaceSettings_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettings().environmentObject(SettingsData())
    }
}
