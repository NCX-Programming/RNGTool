//
//  NumberSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/23/21.
//

import SwiftUI

struct NumberSettings: View {
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var showInputError = false
    @State private var showResetPrompt = false
    @State private var showSuccessAlert = false
    
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
                            maxNumberDefault = 100
                            minNumberDefault = 0
                            showResetPrompt = false
                        },
                        secondaryButton: .cancel()
                    )
                }
                Button(action:{
                    if(maxNumberInput != "" && minNumberInput != ""){
                        maxNumberDefault = Int(maxNumberInput)!
                        minNumberDefault = Int(minNumberInput)!
                        showSuccessAlert = true
                    }
                    else {
                        showInputError = true
                    }
                }) {
                    Text("Save")
                }
                .alert(isPresented: $showInputError){
                    Alert(
                        title: Text("Missing numbers!"),
                        message: Text("You must specify a minimum and maximum number!"),
                        dismissButton: .default(Text("Ok"))
                    )
                }
                .alert(isPresented: $showSuccessAlert){
                    Alert(
                        title: Text("Numbers Set"),
                        message: Text("The following numbers have been set: Max Number: \(maxNumberDefault), Min Number: \(minNumberDefault)"),
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
