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
    @State private var rollTask: Task<Void, Never>? = nil
    
    func resetGen() {
        rollTask?.cancel()
        rollTask = nil
        numDice = 1
        diceImages = Array(repeating: "d1", count: 18)
        confirmReset = false
    }
    
    // Roll function that generates a number for every die being shown in the range 1-6, and then sets each shown die to the image that
    // corresponds with the number rolled for it.
    func roll() {
        randomNumbers = (1...numDice).map { _ in Int.random(in: 1...6) }
        for n in 0..<randomNumbers.count {
            if(numDice > n) { diceImages[n] = "d\(randomNumbers[n])" }
        }
    }
    
    // Function for beginning a roll. Separated from the actual roll, because if the animation is being played, the dice need to be rolled
    // repeatedly.
    func startRoll() {
        // Abort if a roll was somehow triggered while one is already ongoing. This shouldn't be possible since the roll button gets
        // disabled during the roll, but it's here anyway.
        guard rollTask == nil else { return }
        rollTask = Task {
            await MainActor.run {
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) { self.showRollHint = false }
            }
            if settingsData.playAnimations && !reduceMotion {
                for _ in 0..<10 {
                    if Task.isCancelled { return }
                    await MainActor.run {
                        self.roll()
                    }
                    try? await Task.sleep(nanoseconds: 100_000_000) // Why does this have to be nanoseconds? It's 0.1s.
                }
                await MainActor.run {
                    addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Dice Mode")
                    rollCount = 0
                    rollTask = nil
                }
            } else {
                await MainActor.run {
                    self.roll()
                    addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Dice Mode")
                    rollTask = nil
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Text("Copy")
                    }
                }
                .onTapGesture { startRoll() }
                VStack(spacing: 10) {
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
                    .disabled(rollTask != nil)
                    Button(action:{
                        startRoll()
                    }) {
                        Image(systemName: "circle")
                            .opacity(0)
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                            .overlay {
                                Image(systemName: "play.fill")
                            }
                    }
                    .help("Roll the dice")
                    .buttonStyle(LargeSquareAccentButton())
                    .disabled(rollTask != nil)
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true }
                        else { resetGen() }
                    }) {
                        Image(systemName: "circle")
                            .opacity(0)
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                            .overlay {
                                Image(systemName: "clear.fill")
                            }
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
                }
            }
            .padding(.bottom, 10)
        }
        .navigationTitle("Dice")
    }
}

#Preview {
    DiceMode().environmentObject(SettingsData())
}
