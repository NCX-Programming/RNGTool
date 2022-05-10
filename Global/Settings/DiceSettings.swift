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
        Section(header: Text("Dice Settings")) {
            Toggle("Show roll animation", isOn: $settingsData.showDiceAnimation)
        }
    }
}

struct DiceSettings_Previews: PreviewProvider {
    static var previews: some View {
        DiceSettings().environmentObject(SettingsData())
    }
}
