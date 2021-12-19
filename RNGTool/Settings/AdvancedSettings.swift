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
        Toggle("Ask to confirm resetting the generator", isOn: $confirmGenResets)
        Text("Disabling this will allow you to reset the generator without having to confirm it first.")
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
        Text("This will reset all of RNGTool's settings to their default values!")
            .foregroundColor(.secondary)
    }
}

struct AdvancedSettings_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettings()
    }
}
