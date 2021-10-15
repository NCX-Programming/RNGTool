//
//  AdvancedSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 10/14/21.
//

import SwiftUI

struct AdvancedSettings: View {
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
