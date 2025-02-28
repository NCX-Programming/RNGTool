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
    @SceneStorage("NumberMode.randomNumber") private var randomNumber = 0
    @State private var confirmReset: Bool = false
    @State private var maxNumber: Int = 0
    @State private var minNumber: Int = 0
    
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
                    .maxSizeText()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6, alignment: .center)
                    .apply {
                        if #available(macOS 14.0, *) {
                            $0.contentTransition(.numericText(value: Double(randomNumber)))
                        }
                        else if #available(macOS 13.0, *) {
                            $0.contentTransition(.numericText())
                        }
                    }
                    .onAppear { if (settingsData.saveModeStates == false) { randomNumber = 0 } } // Clear on load if we aren't meant to save
                    .contextMenu {
                        Button(action: {
                            copyToClipboard(item: "\(randomNumber)")
                        }) {
                            Text("Copy")
                        }
                    }
                Spacer()
                VStack() {
                    HStack() {
                        Text("Maximum: ")
                            .onAppear { maxNumber = settingsData.maxNumberDefault } // Load default maximum
                        TextField("Enter a number", value: $maxNumber, format: .number)
                            .frame(width: 300)
                    }
                    HStack() {
                        Text("Minimum: ")
                            .onAppear { minNumber = settingsData.minNumberDefault } // Load default minimum
                        TextField("Enter a number", value: $minNumber, format: .number)
                            .frame(width: 300)
                    }
                    .padding(.bottom, 10)
                    Button(action:{
                        if (maxNumber <= minNumber) { minNumber = maxNumber - 1 }
                        if (!reduceMotion && settingsData.playAnimations) {
                            withAnimation { randomNumber = Int.random(in: minNumber...maxNumber) } }
                        else { randomNumber = Int.random(in: minNumber...maxNumber) }
                        addHistoryEntry(settingsData: settingsData, results: "\(randomNumber)", mode: "Number Mode")
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .help("Generate a number")
                    .buttonStyle(LargeSquareAccentButton())
                    Button(action:{
                        if(settingsData.confirmGenResets){
                            confirmReset = true
                        }
                        else {
                            resetGen()
                        }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .help("Reset custom values and output")
                    .buttonStyle(LargeSquareAccentButton())
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
        }
        .navigationTitle("Numbers")
    }
}

#Preview {
    NumberMode().environmentObject(SettingsData())
}
