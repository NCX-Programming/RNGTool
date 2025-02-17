//
//  MarbleMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI
import UIKit
import CoreHaptics

struct MarbleMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var engine: CHHapticEngine?
    @State private var numMarbles: Int = 1
    @State private var rollCount: Int = 0
    @State private var randomNumbers: [Int] = Array(repeating: 0, count: 9)
    @State private var randomLetters: [String] = Array(repeating: "A", count: 9)
    @State private var confirmReset: Bool = false
    @State private var showRollHint: Bool = true
    @State private var letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        numMarbles = 1
        for index in 0..<randomNumbers.count {
            randomNumbers[index] = 0
        }
        randomLetters[0] = "A"
        confirmReset = false
    }

    func roll() {
        randomLetters.removeAll()
        for index in 0..<numMarbles {
            randomNumbers[index] = Int.random(in: 0...25)
        }
        for n in 0..<randomNumbers.count {
            if(numMarbles > n) { randomLetters.append("\(letters[randomNumbers[n]])") }
        }
    }
    
    func startRoll() {
        if(rollCount == 0) { playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1) }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) { self.showRollHint = false }
        if(settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
                self.roll()
                self.rollCount += 1
                if(rollCount == 10) {
                    timer.invalidate(); self.rollCount = 0
                    addHistoryEntry(settingsData: settingsData, results: "\(randomLetters)", mode: "Marble Mode")
                }
            }
        }
        else {
            self.roll()
            addHistoryEntry(settingsData: settingsData, results: "\(randomLetters)", mode: "Marble Mode")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    VStack() {
                        // Same as the dice, draw the marbles in a 3x3 grid by creating a row for each multiple of 3 marbles, and then only
                        // drawing marbles intended for that row in it.
                        ForEach(0..<Int((Double(numMarbles) / 3.0).rounded(.up)), id: \.self) { index in
                            HStack() {
                                ForEach((3 * index)..<(numMarbles > (3 * (index + 1)) ? numMarbles - (numMarbles - (3 * (index + 1))) : numMarbles), id: \.self) { innerIndex in
                                    ZStack() {
                                        Text("\(letters[randomNumbers[innerIndex]])")
                                            // Font calculations are split because using a larger portion of the screen width on iPhone
                                            // produces a better result compared to iPad.
                                            .font(.system(size: (UIDevice.current.userInterfaceIdiom == .pad) ? (geometry.size.width / 14) : (geometry.size.width / 10)))
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 4)
                                    }
                                    .frame(width: getDieSize(geometry: geometry), height: getDieSize(geometry: geometry))
                                    // Making the content shape a rectangle and attaching the onTapGesture here means that you can tap
                                    // anywhere in the invisible rectangle that the marble fits in to roll.
                                    .contentShape(Rectangle())
                                    .onTapGesture { startRoll() }
                                }
                            }
                            
                        }
                    }
                    .padding(.top, 10)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                    .contextMenu {
                        Button(action: {
                            var randomLetterCopyStr = "\(randomLetters)"
                            randomLetterCopyStr.removeAll(where: { removeCharacters.contains($0) } )
                            copyToClipboard(item: "\(randomLetterCopyStr)")
                        }) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
                    // Tapping and shaking are effectively the same, but shaking should only actually trigger a roll if we're supposed to be
                    // reading motion input.
                    .onShake { if(settingsData.useMotionInput) { startRoll() } }
                }
                Spacer()
                VStack() {
                    if(showRollHint && settingsData.showModeHints) {
                        Text("Tap marble to roll")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Text("Number of marbles")
                    Picker("Number of marbles", selection: $numMarbles){
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
                    .help("Roll the marbles")
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.1)
                        if( settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Reset rolled marbles")
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
        .navigationTitle("Marbles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode().environmentObject(SettingsData())
    }
}
