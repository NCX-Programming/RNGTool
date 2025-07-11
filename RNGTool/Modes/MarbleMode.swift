//
//  MarbleMode.swift
//  RNGTool
//
//  Created by Campbell on 9/25/21.
//

import SwiftUI

struct MarbleMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numMarbles: Int = 1
    @State private var randomLetters: [String] = Array(repeating: "A", count: 18)
    @State private var confirmReset: Bool = false
    @State private var showRollHint: Bool = true
    @State private var rollCount: Int = 0
    @State private var letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @State private var rollTask: Task<Void, Never>? = nil
    
    func resetGen() {
        rollTask?.cancel()
        rollTask = nil
        numMarbles = 1
        randomLetters = Array(repeating: "A", count: 18)
        confirmReset = false
    }

    func roll() {
        for i in 0..<numMarbles {
            randomLetters[i] = letters[Int.random(in: 0...25)]
        }
    }
    
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
                    addHistoryEntry(settingsData: settingsData, results: "\(randomLetters)", mode: "Marble Mode")
                    rollCount = 0
                    rollTask = nil
                }
            } else {
                await MainActor.run {
                    self.roll()
                    addHistoryEntry(settingsData: settingsData, results: "\(randomLetters)", mode: "Marble Mode")
                    rollTask = nil
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    VStack() {
                        // Same as the dice, draw the marbles in a 6x3 grid by creating a row for each multiple of 3 marbles, and then only
                        // drawing marbles intended for that row in it.
                        ForEach(0..<Int((Double(numMarbles) / 6.0).rounded(.up)), id: \.self) { index in
                            HStack() {
                                ForEach((6 * index)..<(numMarbles > (6 * (index + 1)) ? numMarbles - (numMarbles - (6 * (index + 1))) : numMarbles), id: \.self) { innerIndex in
                                    ZStack() {
                                        Text("\(randomLetters[innerIndex])")
                                            .font(.system(size: geometry.size.width / 14))
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 4)
                                    }
                                    .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                                    // Making the content shape a rectangle and attaching the onTapGesture here means that you can tap
                                    // anywhere in the invisible rectangle that the marble fits in to roll.
                                    .contentShape(Rectangle())
                                    .onTapGesture { startRoll() }
                                }
                            }
                            
                        }
                    }
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
                }
                Spacer()
                VStack() {
                    if(showRollHint && settingsData.showModeHints) {
                        Text("Click the marbles to roll")
                            .foregroundColor(.secondary)
                    }
                    Picker("Number of marbles:", selection: $numMarbles){
                        ForEach(1...18, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 300)
                    .padding(.bottom, 10)
                    .disabled(rollTask != nil)
                    Button(action:{
                        startRoll()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Roll some marbles")
                    .disabled(rollTask != nil)
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
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
        .navigationTitle("Marbles")
    }
}

#Preview {
    MarbleMode().environmentObject(SettingsData())
}
