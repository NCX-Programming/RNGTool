//
//  CardSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct CardSettings: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        Section(header: Text("Card Settings")) {
            Toggle("Show draw animation", isOn: $settingsData.showCardAnimation)
        }
        #if !os(watchOS)
        Section(footer: Text("Shows the common point values of each card.")) {
            Toggle(isOn: $settingsData.showPoints) {
                Text("Show card point values")
            }
            Picker("Ace Point Value", selection: $settingsData.aceValue){
                Text("1 Point").tag(1)
                Text("11 Points").tag(11)
            }
            #if os(macOS)
                .pickerStyle(RadioGroupPickerStyle())
            #endif
                .disabled(!settingsData.showPoints)
        }
        #endif
    }
}

struct CardSettings_Previews: PreviewProvider {
    static var previews: some View {
        CardSettings().environmentObject(SettingsData())
    }
}
