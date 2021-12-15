//
//  CardSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct CardSettings: View {
    @AppStorage("showPoints") private var showPoints = false
    @AppStorage("aceValue") private var aceValue = 1
    @AppStorage("useFaces") private var useFaces = true
    
    var body: some View {
        Form {
            Text("Card type:")
                .font(.title3)
            Text("Changes whether the card graphics will only use numbers or will include face cards.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Picker("", selection: $useFaces) {
                Text("Faces").tag(true)
                Text("Numbers Only").tag(false)
            }
            #if os(macOS)
                .pickerStyle(RadioGroupPickerStyle())
            #endif
                .padding(.bottom, 12)
            Toggle(isOn: $showPoints) {
                Text("Show card point values")
            }
            Text("This will show what the point value of a card is in most card games.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Ace value:")
                .font(.title3)
                .padding(.top, 12)
            Text("Changes whether the Ace card is worth 1 or 11 points. This setting is ignored if \"Show card point values\" is off.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Picker("", selection: $aceValue){
                Text("1 Point").tag(1)
                Text("11 Points").tag(11)
            }
            #if os(macOS)
                .pickerStyle(RadioGroupPickerStyle())
            #endif
                .disabled(!showPoints)
        }
        .padding(20)
        .frame(width: 350, height: 350)
    }
}

struct CardSettings_Previews: PreviewProvider {
    static var previews: some View {
        CardSettings()
    }
}
