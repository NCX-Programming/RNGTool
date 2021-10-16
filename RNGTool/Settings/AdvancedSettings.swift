//
//  AdvancedSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 10/14/21.
//

import SwiftUI

struct AdvancedSettings: View {
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    @AppStorage("showLetterList") private var showLetterList = false
    @AppStorage("showPoints") private var showPoints = false
    @AppStorage("aceValue") private var aceValue = 1
    @AppStorage("useFaces") private var useFaces = true
    @AppStorage("forceSixSides") private var forceSixSides = false
    @AppStorage("allowDiceImages") private var allowDiceImages = true
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Text("Settings Reset")
                .font(.title3)
            Text("If you'd like to reset all of RNGTool's settings to their defaults, click below.")
                .foregroundColor(.secondary)
            Button(action:{
                showAlert = true
            }) {
                Text("Reset Settings")
            }
            .alert(isPresented: $showAlert){
                Alert(
                    title: Text("Confirm Reset"),
                    message: Text("Are you sure you want to reset all settings to their defaults? This cannot be undone."),
                    primaryButton: .default(Text("Confirm")){
                        maxNumberDefault = 100
                        minNumberDefault = 0
                        showLetterList = false
                        showPoints = false
                        aceValue = 1
                        useFaces = true
                        forceSixSides = false
                        allowDiceImages = true
                        showAlert = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding(20)
        .frame(width: 350, height: 300)
    }
}

struct AdvancedSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettings()
    }
}
