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
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            VStack(alignment: .leading) {
                Text("Change Default Numbers")
                    .font(.title2)
                Text("Default Maximum Number")
                    .padding(.top, 10)
                    .font(.title3)
                TextField("Enter a number:", text: $maxNumberInput)
                    .frame(width: 300)
                Text("Default Minimum Number")
                    .padding(.top, 10)
                    .font(.title3)
                TextField("Enter a number:", text: $minNumberInput)
                    .frame(width: 300)
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
                            minNumberInput = ""
                            maxNumberInput = ""
                            resetNumSet()
                            showResetPrompt = false
                        },
                        secondaryButton: .cancel()
                    )
                }
                Button(action:{
                    if(maxNumberInput == "" || minNumberInput == ""){
                        showAlert = true
                        alertTitle = "Missing numbers!"
                        alertMessage = "You must specify a minimum and maximum number!"
                    }
                    else {
                        settingsData.maxNumberDefault = Int(maxNumberInput)!
                        settingsData.minNumberDefault = Int(minNumberInput)!
                        showAlert = true
                        alertTitle = "Numbers Saved"
                        alertMessage = "Your new maximum and minimum numbers have been saved."
                    }
                }) {
                    Text("Save")
                }
                .alert(isPresented: $showAlert){
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            .padding(.top, 5)
        }
        .padding(20)
        .frame(width: 450, height: 350)
    }
}

struct NumberSettings_Previews: PreviewProvider {
    static var previews: some View {
        NumberSettings()
    }
}
