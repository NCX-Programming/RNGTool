//
//  MarbleSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/27/21.
//

import SwiftUI

struct MarbleSettings: View {
    @StateObject var settingsData: SettingsData = SettingsData()
    
    var body: some View {
        Toggle("Show list of letters", isOn: $settingsData.showLetterList)
        Text("This will make it so that a list of letters will be shown below the marble icons.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings()
    }
}
