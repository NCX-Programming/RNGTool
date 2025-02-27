//
//  DiceMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numDice: Int = 1
    @State private var confirmReset: Bool = false
    @State private var randomNumbers: [Int] = [0]
    @State private var diceImages: [String] = Array(repeating: "d1", count: 18)
    @State private var rollCount: Int = 0
    @State private var showRollHint: Bool = true
    
    func resetGen() {
        numDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    // Roll function that generates a number for every die being shown in the range 1-6, and then sets each shown die to the image that
    // corresponds with the number rolled for it.
    func roll() {
        randomNumbers.removeAll()
        for _ in 1...numDice {
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count {
            if(numDice > n) { diceImages[n] = "d\(randomNumbers[n])" }
        }
    }
    
    // Function for beginning a roll. Separated from the actual roll, because if the animation is being played, the dice need to be rolled
    // repeatedly.
    func startRoll() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) { self.showRollHint = false }
        if (settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.roll()
                self.rollCount += 1
                if (rollCount == 10) {
                    timer.invalidate(); self.rollCount = 0
                    addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Dice Mode")
                }
            }
        }
        else {
            self.roll()
            addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Dice Mode")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    VStack() {
                        // Draw the dice in a 6x3 grid by creating a row for each multiple of 3 dice, and then only drawing dice intended
                        // for that row in it.
                        ForEach(0..<Int((Double(numDice) / 6.0).rounded(.up)), id: \.self) { index in
                            HStack() {
                                ForEach((6 * index)..<(numDice > (6 * (index + 1)) ? numDice - (numDice - (6 * (index + 1))) : numDice), id: \.self) { innerIndex in
                                    Image(diceImages[innerIndex])
                                        .resizable()
                                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                    .contextMenu {
                        Button(action: {
                            copyToClipboard(item: "\(randomNumbers)")
                        }) {
                            Text("Copy")
                        }
                    }
                    .onTapGesture { startRoll() }
                }
                Spacer()
                VStack() {
                    if(showRollHint && settingsData.showModeHints) {
                        Text("Click the dice to roll")
                            .foregroundColor(.secondary)
                    }
                    Picker("Number of dice:", selection: $numDice){
                        ForEach(1...18, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 300)
                    .padding(.bottom, 10)
                    Button(action:{
                        startRoll()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .help("Roll the dice")
                    .buttonStyle(LargeSquareAccentButton())
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true }
                        else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .help("Reset the dice roll")
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
        .navigationTitle("Dice")
    }
}

#Preview {
    DiceMode().environmentObject(SettingsData())
}
