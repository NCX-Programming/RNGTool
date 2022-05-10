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
        Section(header: Text("Marble Settings")) {
            Toggle("Show roll animation", isOn: $settingsData.showMarbleAnimation)
        }
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings().environmentObject(SettingsData())
    }
}
