//
//  DiceSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/22/21.
//

import SwiftUI

struct DiceSettings: View {
    @AppStorage("forceSixSides") private var forceSixSides = false

    var body: some View {
        Form {
            Toggle("Force 6 sides per die", isOn: $forceSixSides)
            Text("This will make it so that the dice images will always be shown")
                .foregroundColor(.secondary)
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct DiceSettings_Previews: PreviewProvider {
    static var previews: some View {
        DiceSettings()
    }
}
