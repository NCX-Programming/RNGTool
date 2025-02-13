//
//  MarbleSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/27/21.
//

import SwiftUI

struct MarbleSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        // Below is a placeholder, as these settings are not used anymore
        Section(header: Text("Marble Mode")) {
            Toggle("Dummy setting", isOn: $settingsData.dummyKey)
        }
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings().environmentObject(SettingsData())
    }
}
