//
//  NumberMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI
import CoreHaptics

struct NumberMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @SceneStorage("NumberMode.randomNumber") private var randomNumber = 0
    @State private var maxNumber: Int = 100
    @State private var minNumber: Int = 0
    @State private var engine: CHHapticEngine?
    @State private var confirmReset: Bool = false
    // Enum for the @FocusState used to dismiss the keyboard when a button is pressed
    enum Field {
        case maxNumber
        case minNumber
    }
    @FocusState private var fieldFocused: Field?
    
    func resetGen() {
        maxNumber = settingsData.maxNumberDefault
        minNumber = settingsData.minNumberDefault
        if (!reduceMotion && settingsData.playAnimations) { withAnimation { randomNumber = 0 } } else { randomNumber = 0 }
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Text("\(randomNumber)")
                    // This code is to make the text showing the random number as big as possible while fitting the screen, fitting above
                    // the buttons, and not truncating.
                    .maxSizeText()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6, alignment: .center)
                    .onAppear { if (settingsData.saveModeStates == false) { randomNumber = 0 } } // Clear on load if we aren't meant to save
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0.contentTransition(.numericText(value: Double(randomNumber)))
                        }
                        else if #available(iOS 16.0, *) {
                            $0.contentTransition(.numericText())
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            copyToClipboard(item: "\(randomNumber)")
                        }) {
                            Text("Copy")
                            Image(systemName: "document.on.document")
                        }
                    }
                Spacer()
                VStack() {
                    Text("Maximum")
                    TextField("Enter a number", value: $maxNumber, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .focused($fieldFocused, equals: .maxNumber)
                        .onAppear { maxNumber = settingsData.maxNumberDefault } // Load default maximum
                    Text("Minimum")
                    TextField("Enter a number", value: $minNumber, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .focused($fieldFocused, equals: .minNumber)
                        .onAppear { minNumber = settingsData.minNumberDefault } // Load default minimum
                        .padding(.bottom, 10)
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
                        fieldFocused = .none // Dismisses the keyboard, if it's open
                        if (maxNumber <= minNumber) { minNumber = maxNumber - 1 }
                        if (!reduceMotion && settingsData.playAnimations) {
                            withAnimation { randomNumber = Int.random(in: minNumber...maxNumber) } }
                        else { randomNumber = Int.random(in: minNumber...maxNumber) }
                        addHistoryEntry(settingsData: settingsData, results: "\(randomNumber)", mode: "Number Mode")
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Generate a number")
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.2)
                        fieldFocused = .none // Dismisses the keyboard, if it's open
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Reset custom values and output")
                    .alert("Confirm Reset", isPresented: $confirmReset, actions: {
                        Button("Confirm", role: .destructive) {
                            resetGen()
                        }
                    }, message: {
                        Text("Are you sure you want to reset the generator?")
                    })
                    .padding(.bottom, 10)
                }
            }
            .onAppear { prepareHaptics(engine: &engine) }
            .navigationTitle("Numbers")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode().environmentObject(SettingsData())
    }
}
