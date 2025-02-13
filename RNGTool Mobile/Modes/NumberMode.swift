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
    @SceneStorage("NumberMode.randomNumber") private var randomNumber = 0
    @State private var maxNumber = 0
    @State private var minNumber = 0
    @State private var engine: CHHapticEngine?
    @State private var confirmReset = false
    @State private var showMaxEditor = false
    @State private var showMinEditor = false
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    
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
            Text("\(randomNumber)")
                .font(.title)
                .padding(.bottom, 5)
                .onAppear {
                    if (settingsData.saveModeStates == false) { randomNumber = 0 }
                }
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: "\(randomNumber)")
                    }) {
                        Text("Copy")
                    }
                }
            Group() {
                Text("Maximum: \(maxNumberInput). Tap to change.")
                    .onTapGesture {
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                            showMaxEditor.toggle()
                        }
                    }
                    .help("Tap here to set a custom maximum number")
                    .onAppear{
                        maxNumberInput = "\(maxNumber)"
                        if (maxNumber == 0 || settingsData.saveModeStates == false) { maxNumberInput = "\(settingsData.maxNumberDefault)" }
                    }
                if(showMaxEditor){
                    TextField("Enter a number", text: $maxNumberInput)
                        .keyboardType(.numberPad)
                }
                Divider()
                Text("Minimum: \(minNumber). Tap to change.")
                    .onTapGesture {
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                            showMinEditor.toggle()
                        }
                    }
                    .help("Tap here to set a custom minimum number")
                    .onAppear {
                        minNumberInput = "\(minNumber)"
                        if (minNumber == 0 || settingsData.saveModeStates == false) { minNumberInput = "\(settingsData.minNumberDefault)" }
                    }
                if(showMinEditor){
                    TextField("Enter a number", text: $minNumberInput)
                        .keyboardType(.numberPad)
                }
                Divider()
            }
            .onChange(of: maxNumberInput) { maxNumberInput in
                maxNumber = Int(maxNumberInput.prefix(19)) ?? settingsData.maxNumberDefault
            }
            .onChange(of: minNumberInput) { minNumberInput in
                minNumber = Int(minNumberInput.prefix(19)) ?? settingsData.minNumberDefault
            }
            HStack {
                Button(action:{
                    playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.2)
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
