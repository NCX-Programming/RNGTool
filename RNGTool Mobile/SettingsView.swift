//
//  SettingsView.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/14/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showResetPrompt = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAdvSet = false
    
    var body: some View {
        Form {
            Section(header: Text("Number Settings")) {
                Text("Default Maximum Number")
                TextField(text: $maxNumberInput, prompt: Text("Required")) {
                    Text("Max Number")
                }
                Text("Default Minimum Number")
                TextField(text: $minNumberInput, prompt: Text("Required")) {
                    Text("Min Number")
                }
                .onAppear {
                    maxNumberInput = "\(maxNumberDefault)"
                    minNumberInput = "\(minNumberDefault)"
                }
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
                        maxNumberDefault = Int(maxNumberInput)!
                        minNumberDefault = Int(minNumberInput)!
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
            Section(header: Text("Dice Settings")) {
                DiceSettings()
            }
            Section(header: Text("Card Settings")) {
                CardSettings()
            }
            Section(header: Text("Marble Settings")) {
                MarbleSettings()
            }
            Section(header: Text("Advanced Settings")) {
                Button(action:{
                    showAdvSet = true
                }) {
                    Text("Show Advanced Settings")
                }
            }
        }
        Text("RNGTool Version: v\(appVersionString), Build: \(buildNumber)")
            .foregroundColor(.secondary)
            .font(.caption)
        Text("© 2021 NCX Programming")
            .foregroundColor(.secondary)
            .font(.caption)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAdvSet, content: {
            AdvancedSettingsView()
        })
    }
}

struct AdvancedSettingsView: View {
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                AdvancedSettings()
            }
            .navigationBarTitle("Advanced Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
