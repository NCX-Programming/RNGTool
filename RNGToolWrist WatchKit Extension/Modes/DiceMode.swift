//
//  DiceMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI
import WatchKit

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numDice: Int = 1
    @State private var confirmReset: Bool = false
    @State private var randomNumbers: [Int] = [0]
    @State private var diceImages: [String] = Array(repeating: "d1", count: 2)
    @State private var rollCount: Int = 0
    @State private var showRollHint: Bool = true
    
    func resetGen() {
        numDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    func roll() {
        randomNumbers.removeAll()
        for _ in 0..<numDice {
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count {
            if (numDice>n) {diceImages[n]="d\(randomNumbers[n])"}
        }
    }
    
    func startRoll() {
        WKInterfaceDevice.current().play(.click)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            showRollHint = false
        }
        if(settingsData.playAnimations && !reduceMotion && rollCount == 0) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                roll()
                rollCount += 1
                if (rollCount == 10) { timer.invalidate(); rollCount = 0 }
            }
        }
        else { roll() }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
                    HStack() {
                        ForEach(0..<numDice, id: \.self) { index in
                          Image(diceImages[index])
                            .resizable()
                            .frame(width: (geometry.size.width / 2.5) - 10, height: (geometry.size.width / 2.5) - 10)
                        }
                    }
                    .onTapGesture { startRoll() }
                    if (showRollHint && settingsData.showModeHints) {
                        Text("Tap dice to roll")
                            .foregroundColor(.secondary)
                    }
                    HStack() {
                        Picker("", selection: $numDice){
                            ForEach(1...2, id: \.self) { index in
                                Text("\(index)").tag(index)
                            }
                        }
                        .frame(width: geometry.size.width / 3)
                        Text("Number of Dice")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height / 2, alignment: .center)
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                    }
                    .font(.system(size: 20, weight:.bold, design: .rounded))
                    .foregroundColor(.red)
                    .alert("Confirm Reset", isPresented: $confirmReset, actions: {
                        Button("Confirm", role: .destructive) {
                            resetGen()
                        }
                    }, message: {
                        Text("Are you sure you want to reset the generator?")
                    })
                }
            }
        }
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DiceMode().environmentObject(SettingsData())
}
