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
        Toggle("Show card animation", isOn: $settingsData.showCardAnimation)
        Text("This changes whether or not the card images will appear one at a time.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        Picker("Card Style", selection: $settingsData.useFaces) {
            Text("Faces").tag(true)
            Text("Numbers Only").tag(false)
        }
        #if os(macOS)
            .pickerStyle(RadioGroupPickerStyle())
        #endif
        Text("Changes whether the card graphics will only use numbers or will include face cards.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        #if !os(watchOS)
        Toggle(isOn: $settingsData.showPoints) {
            Text("Show card point values")
        }
        Text("This will show what the point value of a card is in most card games.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        Picker("Ace Point Value", selection: $settingsData.aceValue){
            Text("1 Point").tag(1)
            Text("11 Points").tag(11)
        }
        #if os(macOS)
            .pickerStyle(RadioGroupPickerStyle())
        #endif
            .disabled(!settingsData.showPoints)
        Text("Changes whether the Ace card is worth 1 or 11 points. This setting is ignored if \"Show card point values\" is off.")
            .font(.subheadline)
            .foregroundColor(.secondary)
        #endif
    }
}

struct CardSettings_Previews: PreviewProvider {
    static var previews: some View {
        CardSettings()
    }
}
