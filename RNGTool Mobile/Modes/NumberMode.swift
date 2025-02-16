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
    @State private var maxNumberInput: String = ""
    @State private var minNumberInput: String = ""
    // Enum for the @FocusState used to dismiss the keyboard when a button is pressed
    enum Field {
        case maxNumber
        case minNumber
    }
    @FocusState private var fieldFocused: Field?
    
    func resetGen() {
        maxNumberInput = "\(settingsData.maxNumberDefault)"
        minNumberInput = "\(settingsData.minNumberDefault)"
        randomNumber = 0
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Text("\(randomNumber)")
                    // This code is to make the text showing the random number as big as possible while fitting the screen, fitting above
                    // the buttons, and not truncating.
                    .font(.system(size: 1000))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6, alignment: .center)
                    .allowsTightening(true)
                    .onAppear {
                        if (settingsData.saveModeStates == false) { randomNumber = 0 }
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
                    TextField("Enter a number", text: $maxNumberInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .focused($fieldFocused, equals: .maxNumber)
                        .onChange(of: maxNumberInput) { maxNumberInput in
                            maxNumber = Int(maxNumberInput.prefix(19)) ?? settingsData.maxNumberDefault
                        }
                        .onAppear { maxNumberInput = "\(settingsData.maxNumberDefault)" } // Load default maximum
                    Text("Minimum")
                    TextField("Enter a number", text: $minNumberInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .focused($fieldFocused, equals: .minNumber)
                        .onChange(of: minNumberInput) { minNumberInput in
                            minNumber = Int(minNumberInput.prefix(19)) ?? settingsData.minNumberDefault
                        }
                        .onAppear { minNumberInput = "\(settingsData.minNumberDefault)" } // Load default minimum
                        .padding(.bottom, 10)
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
                        fieldFocused = .none // Dismisses the keyboard, if it's open
                        if (maxNumber <= minNumber) { minNumber = maxNumber - 1 }
                        randomNumber = Int.random(in: minNumber...maxNumber)
                        // This fixes the displayed numbers if they were invalid
                        maxNumberInput="\(maxNumber)"
                        minNumberInput="\(minNumber)"
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
            //.padding(.horizontal, 3)
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
