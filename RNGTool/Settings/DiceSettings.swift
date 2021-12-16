//
//  DiceSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct DiceSettings: View {
    @AppStorage("forceSixSides") private var forceSixSides = false
    @AppStorage("allowDiceImages") private var allowDiceImages = true

    var body: some View {
        Toggle("Enable dice images", isOn: $allowDiceImages)
        Text("Show images of the rolled dice. This is enabled by default.")
            .foregroundColor(.secondary)
        Toggle("Force 6 sides per die", isOn: $forceSixSides)
            .disabled(!allowDiceImages)
        Text("This will make it so that the dice images will always be shown.")
            .foregroundColor(.secondary)
    }
}

struct DiceSettings_Previews: PreviewProvider {
    static var previews: some View {
        DiceSettings()
    }
}
