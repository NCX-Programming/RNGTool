//
//  NumberMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI
import WatchKit

struct NumberMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var confirmReset = false
    @State private var showRollHint = true
    @State private var showNumKeyboard = false
    @State private var randomNumber = 0
    @State private var randomNumberStr = "0"
    @State private var maxNumber = 100
    @State private var minNumber = 0
    @State private var keyboardNumber = 0
    @State private var kbReturnType = 1
    
    func resetGen() {
        randomNumber = 0
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
            randomNumberStr = "0"
        }
        maxNumber = settingsData.maxNumberDefault
        minNumber = settingsData.minNumberDefault
        confirmReset = false
    }

    var body: some View {
        ScrollView {
            Text(randomNumberStr)
                .font(.title)
                .onTapGesture {
                    WKInterfaceDevice.current().play(.click)
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                        self.showRollHint = false
                    }
                    randomNumber = Int.random(in: minNumber...maxNumber)
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
                        self.randomNumberStr = "\(randomNumber)"
                    }
                }
            if(showRollHint && settingsData.showModeHints) {
                Text("Tap number to generate")
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack() {
                Button(action: {
                    kbReturnType = 1
                    keyboardNumber = maxNumber
                    showNumKeyboard = true
                }) {
                    Text("Max: \(maxNumber)")
                }
            }
            VStack() {
                Button(action: {
                    kbReturnType = 2
                    keyboardNumber = minNumber
                    showNumKeyboard = true
                }) {
                    Text("Min: \(minNumber)")
                }
            }
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
            .font(.system(size: 20, weight:.bold, design: .rounded))
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
            .sheet(isPresented: $showNumKeyboard) {
                NumKeyboard(targetNumber: $keyboardNumber)
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { self.showNumKeyboard = false }
                    }
                })
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            if(kbReturnType == 1) {
                                maxNumber = keyboardNumber
                            }
                            else if(kbReturnType == 2) {
                                minNumber = keyboardNumber
                            }
                            self.showNumKeyboard = false
                        }
                    }
                })
            }
        }
        .navigationTitle("Numbers")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            maxNumber = settingsData.maxNumberDefault
            minNumber = settingsData.minNumberDefault
        }
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode().environmentObject(SettingsData())
    }
}
