//
//  InterfaceSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/2/22.
//

import SwiftUI

struct InterfaceSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        Section(header: Text("Interface"), footer: Text("Disable tap hints to hide text like \"Tap to roll\".")) {
            Toggle("Ask to confirm resets", isOn: $settingsData.confirmGenResets)
            Toggle("Show tap hints", isOn: $settingsData.showModeHints)
        }
    }
}

struct InterfaceSettings_Previews: PreviewProvider {
    static var previews: some View {
        InterfaceSettings().environmentObject(SettingsData())
    }
}
