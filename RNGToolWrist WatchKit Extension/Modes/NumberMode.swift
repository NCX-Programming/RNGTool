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
    @State private var randomNumber = 0
    @State private var randomNumberStr = ""
    
    func resetGen() {
        randomNumber = 0
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
            randomNumberStr = ""
        }
        confirmReset = false
    }
    
    var body: some View {
        ScrollView {
            Text("Your random number:")
            Text(randomNumberStr)
            Spacer()
            Button(action:{
                randomNumber = Int.random(in: settingsData.minNumberDefault...settingsData.maxNumberDefault)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
                    self.randomNumberStr = "\(randomNumber)"
                }
            }) {
                Image(systemName: "play.fill")
                    
            }
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.primary)
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
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode()
    }
}
