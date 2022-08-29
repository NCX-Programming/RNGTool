//
//  NumberSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/23/21.
//

import SwiftUI

struct NumberSettings: View {
    @StateObject var settingsData: SettingsData = SettingsData()
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showResetPrompt = false
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Change Default Numbers")
                    .font(.title2)
                TextField("Maximum Number:", text: $maxNumberInput)
                    .frame(width: 300)
                    .onChange(of: maxNumberInput) { maxNumberInput in
                        settingsData.maxNumberDefault = Int(maxNumberInput) ?? 100
                    }
                TextField("Minimum Number:", text: $minNumberInput)
                    .frame(width: 300)
                    .onChange(of: minNumberInput) { minNumberInput in
                        settingsData.minNumberDefault = Int(minNumberInput) ?? 0
                    }
            }
            .onAppear {
                maxNumberInput = "\(settingsData.maxNumberDefault)"
                minNumberInput = "\(settingsData.minNumberDefault)"
            }
            HStack() {
                Button(action:{
                    showResetPrompt = true
                }) {
                    Text("Reset")
                }
                .alert(isPresented: $showResetPrompt){
                    Alert(
                        title: Text("Confirm Reset"),
                        message: Text("Are you sure you want to reset the minimum and maximum numbers to their defaults? This cannot be undone."),
                        primaryButton: .default(Text("Confirm")){
                            maxNumberInput = "100"
                            minNumberInput = "0"
                            showResetPrompt = false
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding(.top, 5)
        }
    }
}

struct NumberSettings_Previews: PreviewProvider {
    static var previews: some View {
        NumberSettings()
    }
}
