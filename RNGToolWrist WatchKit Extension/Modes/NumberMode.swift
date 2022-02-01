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
            Text(randomNumberStr)
                .padding(.bottom, 5)
            Button(action:{
                maxNumber = Int(maxNumberInput) ?? settingsData.maxNumberDefault
                minNumber = Int(minNumberInput) ?? settingsData.minNumberDefault
                randomNumber = Int.random(in: minNumber..<maxNumber)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                    showCopy = true
                    self.randomNumberStr = "Your random number: \(randomNumber)"
                }
                maxNumberInput="\(maxNumber)"
                minNumberInput="\(minNumber)"
                if !(settingsData.historyTable.count > 49) {
                    settingsData.historyTable.append(HistoryTable(modeUsed: "Number Mode", numbers: "\(randomNumber)"))
                }
                else {
                    settingsData.historyTable.remove(at: 0)
                    settingsData.historyTable.append(HistoryTable(modeUsed: "Number Mode", numbers: "\(randomNumber)"))
                }
            }) {
                Image(systemName: "play.fill")
                    
            }
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(5)
            .cornerRadius(20)
        }
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode()
    }
}
