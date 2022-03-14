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
        Toggle("Show marble animation", isOn: $settingsData.showMarbleAnimation)
        Text("This changes whether or not the marbles will cycle through letters before stopping at one.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings()
    }
}
