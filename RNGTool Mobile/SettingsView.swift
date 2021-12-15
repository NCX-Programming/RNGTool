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
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showResetPrompt = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Group{
                    Text("Number Mode")
                        .font(.title)
                    Spacer()
                    Text("Change Default Numbers")
                        .font(.title2)
                    Text("Default Maximum Number")
                        .font(.title3)
                    TextField("Enter a number:", text: $maxNumberInput)
                    Divider()
                    Text("Default Minimum Number")
                        .font(.title3)
                    TextField("Enter a number:", text: $minNumberInput)
                    Divider()
                    .onAppear {
                        maxNumberInput = "\(maxNumberDefault)"
                        minNumberInput = "\(minNumberDefault)"
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
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
