//
//  NumberMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI

struct NumberMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var confirmReset = false
    @State private var showRollHint = true
    @State private var randomNumber = 0
    @State private var randomNumberStr = "0"
    @State private var maxNumber = 100
    @State private var minNumber = 0
    
    func resetGen() {
        randomNumber = 0
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
            randomNumberStr = "0"
        }
        maxNumber = 100
        minNumber = 0
        confirmReset = false
    }

    var body: some View {
        ScrollView {
            Text(randomNumberStr)
                .font(.title)
                .onTapGesture {
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
                Text("Max: \(maxNumber)")
                HStack() {
                    Button(action:{
                        if(maxNumber > minNumber) { maxNumber -= 1 }
                    }) {
                        Image(systemName: "minus")
                            
                    }
                    Button(action:{
                        maxNumber += 1
                    }) {
                        Image(systemName: "plus")
                            
                    }
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.primary)
            }
            VStack() {
                Text("Min: \(minNumber)")
                HStack() {
                    Button(action:{
                        if(minNumber > 0) { minNumber -= 1 }
                    }) {
                        Image(systemName: "minus")
                            
                    }
                    Button(action:{
                        if(minNumber < maxNumber) { minNumber += 1 }
                    }) {
                        Image(systemName: "plus")
                            
                    }
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.primary)
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
        }
        .navigationTitle("Numbers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode().environmentObject(SettingsData())
    }
}
