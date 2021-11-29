//
//  AdvancedSettings.swift
//  RNGTool
//
//  Created by Campbell on 10/14/21.
//

import SwiftUI

struct AdvancedSettings: View {
    @AppStorage("confirmGenResets") private var confirmGenResets = true
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Toggle("Ask to confirm resetting the generator", isOn: $confirmGenResets)
            Text("Disabling this will allow you to reset the generator without having to confirm it first.")
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
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
                        resetNumSet()
                        resetDiceSet()
                        resetCardSet()
                        resetMarbleSet()
                        confirmGenResets = true
                        showAlert = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding(20)
        .frame(width: 350, height: 350)
    }
}

struct AdvancedSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettings()
    }
}
