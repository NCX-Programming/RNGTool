//
//  CardSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/22/21.
//

import SwiftUI

struct CardSettings: View {
    @AppStorage("showPoints") private var showPoints = false
    @AppStorage("aceValue") private var aceValue = 1
    
    var body: some View {
        Form {
            Toggle(isOn: $showPoints) {
                Text("Show card point values")
            }
            Text("Ace value:")
                .font(.title3)
            Text("Changes whether the Ace card is worth 1 or 11 points. This setting is ignored if \"Show card point values\" is off.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Picker("", selection: $aceValue){
                Text("1 Point").tag(1)
                Text("11 Points").tag(11)
            }.pickerStyle(RadioGroupPickerStyle())
            .disabled(!showPoints)
        }
        .padding(20)
        .frame(width: 350, height: 400)
    }
}

struct CardSettings_Previews: PreviewProvider {
    static var previews: some View {
        CardSettings()
    }
}
