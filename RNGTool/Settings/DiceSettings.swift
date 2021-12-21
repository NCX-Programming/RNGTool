//
//  DiceSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct DiceSettings: View {
    @StateObject var settingsData: SettingsData = SettingsData()

    var body: some View {
        Toggle("Enable dice images", isOn: $settingsData.allowDiceImages)
        Text("Show images of the rolled dice. This is enabled by default.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        Toggle("Force 6 sides per die", isOn: $settingsData.forceSixSides)
            .disabled(!settingsData.allowDiceImages)
        Text("This will make it so that the dice images will always be shown.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
}

struct DiceSettings_Previews: PreviewProvider {
    static var previews: some View {
        DiceSettings()
    }
}
