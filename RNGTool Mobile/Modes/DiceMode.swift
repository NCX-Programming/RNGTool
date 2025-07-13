//
//  DiceMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI
import CoreHaptics

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var engine: CHHapticEngine?
    @State private var numDice: Int = 1
    @State private var confirmReset: Bool = false
    @State private var randomNumbers: [Int] = [0]
    @State private var diceImages: [String] = Array(repeating: "d1", count: 9)
    @State private var rollCount: Int = 0
    @State private var showRollHint: Bool = true
    @State private var rollTask: Task<Void, Never>? = nil
    
    func resetGen() {
        rollTask?.cancel()
        rollTask = nil
        numDice = 1
        diceImages = Array(repeating: "d1", count: 9)
        confirmReset = false
    }
    
    // Roll function that generates a number for every die being shown in the range 1-6, and then sets each shown die to the image that
    // corresponds with the number rolled for it.
    func roll() {
        randomNumbers = (1...numDice).map { _ in Int.random(in: 1...6) }
        for n in 0..<randomNumbers.count{
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
            playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
            await MainActor.run {
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) { self.showRollHint = false }
            }
            if settingsData.playAnimations && !reduceMotion {
                for _ in 0..<10 {
                    if Task.isCancelled { return }
                    await MainActor.run {
                        self.roll()
                    }
                    playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
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
                    // Draw the dice in a 3x3 grid by creating a row for each multiple of 3 dice, and then only drawing dice intended
                    // for that row in it.
                    ForEach(0..<Int((Double(numDice) / 3.0).rounded(.up)), id: \.self) { index in
                        HStack() {
                            ForEach((3 * index)..<(numDice > (3 * (index + 1)) ? numDice - (numDice - (3 * (index + 1))) : numDice), id: \.self) { innerIndex in
                                Image(diceImages[innerIndex])
                                    .resizable()
                                    .frame(width: getDieSize(geometry: geometry), height: getDieSize(geometry: geometry))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
                // Tapping and shaking trigger the same code, but the shake gesture should only trigger a roll if motion input is
                // currently enabled.
                .onTapGesture { startRoll() }
                .onShake { if(settingsData.useMotionInput) { startRoll() } }
                VStack(spacing: 10) {
                    if (showRollHint && settingsData.showModeHints) {
                        Text("Tap the die to roll")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Text("Number of dice")
                    Picker("Number of dice", selection: $numDice){
                        ForEach(1...9, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, geometry.size.width * 0.075)
                    .disabled(rollTask != nil)
                    Button(action:{
                        startRoll()
                    }) {
                        Image(systemName: "circle")
                            .opacity(0)
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                            .overlay {
                                Image(systemName: "play.fill")
                            }
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Roll the dice")
                    .disabled(rollTask != nil)
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.2)
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "circle")
                            .opacity(0)
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                            .overlay {
                                Image(systemName: "clear.fill")
                            }     
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Reset dice count and roll")
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
        .onAppear { prepareHaptics(engine: &engine) }
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
