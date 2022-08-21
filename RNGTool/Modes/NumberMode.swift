//
//  NumberMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }
}

struct NumberMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var confirmReset = false
    @State private var showMaxEditor = false
    @State private var showMinEditor = false
    @State private var randomNumber = 0
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var maxNumber = 0
    @State private var minNumber = 0
    
    func resetGen() {
        maxNumber = 0
        maxNumberInput = "\(settingsData.maxNumberDefault)"
        minNumber = 0
        minNumberInput = "\(settingsData.minNumberDefault)"
        randomNumber = 0
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            showMaxEditor = false
            showMinEditor = false
        }
        confirmReset = false
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                Text("\(randomNumber)")
                    .font(.system(size: 48))
                    .padding(.bottom, 5)
                    .contextMenu {
                        Button(action: {
                            copyToClipboard(item: "\(randomNumber)")
                        }) {
                            Text("Copy")
                        }
                    }
                Group() {
                    Text("Maximum Number: \(maxNumberInput). Click to change.")
                        .onTapGesture {
                            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                                showMaxEditor.toggle()
                            }
                        }
                        .help("Click to set a custom maximum number")
                        .font(.title2)
                        .onAppear{
                            maxNumberInput="\(settingsData.maxNumberDefault)"
                        }
                    if(showMaxEditor){
                        TextField("Enter a number", text: $maxNumberInput)
                            .frame(width: 300)
                    }
                    Divider()
                    Text("Minimum Number: \(settingsData.minNumberDefault). Click to change.")
                        .onTapGesture {
                            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                                showMinEditor.toggle()
                            }
                        }
                        .help("Click to set a custom minimum number")
                        .font(.title2)
                        .onAppear{
                            minNumberInput="\(settingsData.minNumberDefault)"
                        }
                    if(showMinEditor){
                        TextField("Enter a number", text: $minNumberInput)
                            .frame(width: 300)
                    }
                    Divider()
                }
                HStack {
                    Button(action:{
                        maxNumber = Int(maxNumberInput.prefix(19)) ?? settingsData.maxNumberDefault
                        minNumber = Int(minNumberInput.prefix(19)) ?? settingsData.minNumberDefault
                        if (maxNumber <= minNumber) { minNumber = settingsData.minNumberDefault }
                        randomNumber = Int.random(in: minNumber...maxNumber)
                        maxNumberInput="\(maxNumber)"
                        minNumberInput="\(minNumber)"
                        addHistoryEntry(settingsData: settingsData, results: "\(randomNumber)", mode: "Number Mode")
                    }) {
                        Image(systemName: "play.fill")
                            
                    }
                    .help("Generate a number")
                    Button(action:{
                        if(settingsData.confirmGenResets){
                            confirmReset = true
                        }
                        else {
                            resetGen()
                        }
                    }) {
                        Image(systemName: "clear.fill")
                    }
                    .help("Reset custom values and output")
                    .foregroundColor(.red)
                    .alert(isPresented: $confirmReset){
                        Alert(
                            title: Text("Confirm Reset"),
                            message: Text("Are you sure you want to reset the generator? This cannot be undone."),
                            primaryButton: .default(Text("Confirm")){
                                resetGen()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding(.leading, 12)
        }
        .navigationTitle("Numbers")
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode().environmentObject(SettingsData())
    }
}
