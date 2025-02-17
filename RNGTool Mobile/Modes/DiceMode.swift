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
    @State private var randomNumberStr: String = ""
    @State private var diceImages: [String] = Array(repeating: "d1", count: 9)
    @State private var rollCount: Int = 0
    @State private var showRollHint: Bool = true
    
    func resetGen() {
        randomNumberStr = ""
        numDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    // Roll function that generates a number for every die being shown in the range 1-6, and then sets each shown die to the image that
    // corresponds with the number rolled for it.
    func roll() {
        randomNumbers.removeAll()
        for _ in 1...numDice{
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count{
            if(numDice > n) { diceImages[n] = "d\(randomNumbers[n])" }
        }
        self.randomNumberStr = "Your random number(s): \(randomNumbers)"
        randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
    }
    
    // Function for beginning a roll. Separated from the actual roll, because if the animation is being played, the dice need to be rolled
    // repeatedly.
    func startRoll() {
        if (rollCount == 0) { playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1) }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) { self.showRollHint = false }
        if (settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                // Play a single haptic tap for every roll in the animation. (It's more fun this way!)
                playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
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
                    .padding(.top, 10)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
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
                }
                Spacer()
                VStack() {
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
                    .padding(.bottom, 10)
                    Button(action:{
                        startRoll()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Roll the dice")
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.2)
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
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
                    .padding(.bottom, 10)
                }
            }
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
