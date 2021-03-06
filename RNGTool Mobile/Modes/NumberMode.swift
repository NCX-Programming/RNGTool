//
//  NumberMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI
import CoreHaptics

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }
}

struct NumberMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var engine: CHHapticEngine?
    @State private var confirmReset = false
    @State private var showMaxEditor = false
    @State private var showMinEditor = false
    @State private var showCopy = false
    @State private var randomNumber = 0
    @State private var randomNumberStr = ""
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
            randomNumberStr = ""
            showMaxEditor = false
            showMinEditor = false
            showCopy = false
        }
        confirmReset = false
    }
    
    var body: some View {
        ScrollView {
            Text("Generate a single number using a maximum and minimum number")
                .font(.title3)
            Divider()
            Text(randomNumberStr)
                .font(.title2)
                .padding(.bottom, 5)
            if(showCopy){
                Button(action:{
                    copyToClipboard(item: "\(randomNumber)")
                }) {
                    Image(systemName: "doc.on.doc.fill")
                }
                .font(.system(size: 12, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
                .padding(.bottom, 10)
                Divider()
            }
            Group() {
                Text("Maximum Number: \(maxNumberInput). Tap to set a custom value.")
                    .onTapGesture {
                        showMaxEditor.toggle()
                    }
                    .help("Tap here to set a custom maximum number")
                    .onAppear{
                        maxNumberInput="\(settingsData.maxNumberDefault)"
                    }
                if(showMaxEditor){
                    TextField("Enter a number", text: $maxNumberInput)
                        .keyboardType(.numberPad)
                }
                Divider()
                Text("Minimum Number: \(settingsData.minNumberDefault). Tap to set a custom value.")
                    .onTapGesture {
                        showMinEditor.toggle()
                    }
                    .help("Tap here to set a custom minimum number")
                    .onAppear{
                        minNumberInput="\(settingsData.minNumberDefault)"
                    }
                if(showMinEditor){
                    TextField("Enter a number", text: $minNumberInput)
                        .keyboardType(.numberPad)
                }
                Divider()
            }
            HStack {
                Button(action:{
                    playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.2)
                    maxNumber = Int(maxNumberInput) ?? settingsData.maxNumberDefault
                    minNumber = Int(minNumberInput) ?? settingsData.minNumberDefault
                    randomNumber = Int.random(in: minNumber...maxNumber)
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                        showCopy = true
                        self.randomNumberStr = "Your random number: \(randomNumber)"
                    }
                    maxNumberInput="\(maxNumber)"
                    minNumberInput="\(minNumber)"
                    addHistoryEntry(settingsData: settingsData, results: "\(randomNumber)", mode: "Number Mode")
                }) {
                    Image(systemName: "play.fill")
                        
                }
                .onAppear { prepareHaptics(engine: &engine) }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
                .help("Generate a number")
                Button(action:{
                    playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.1)
                    if(settingsData.confirmGenResets){
                        confirmReset = true
                    }
                    else { resetGen() }
                }) {
                    Image(systemName: "clear.fill")
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
                .help("Reset custom values and output")
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
        .padding(.horizontal, 3)
        .navigationTitle("Numbers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode().environmentObject(SettingsData())
    }
}
