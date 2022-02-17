//
//  DiceSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct DiceSettings: View {
    @EnvironmentObject var settingsData: SettingsData

    var body: some View {
        Toggle("Show dice animation", isOn: $settingsData.showDiceAnimation)
        Text("This changes whether or not the dice images will cycle through images before stopping at one.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

struct DiceSettings_Previews: PreviewProvider {
    static var previews: some View {
        DiceSettings()
    }
}
