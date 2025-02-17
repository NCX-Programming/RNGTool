//
//  CoinMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 2/15/25.
//

import SwiftUI
import CoreHaptics

struct CoinMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var headsCount: Int = 0
    @State private var tailsCount: Int = 0
    @State private var coinCount: Int = 0
    @State private var numCoins: Int = 1
    @State private var flipCount: Int = 0
    @State private var engine: CHHapticEngine?
    @State private var confirmReset: Bool = false
    
    func resetGen() {
        headsCount = 0
        tailsCount = 0
        coinCount = 0
        numCoins = 1
        confirmReset = false
    }
    
    func flipCoin() {
        let coinInt = Int.random(in: 0...1)
        if (coinInt == 1) {
            headsCount += 1
        } else {
            tailsCount += 1
        }
        coinCount += 1
    }
    
    func flipCoins() {
        if (flipCount == 0) { playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1) }
        Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { timer in
            // Play a single haptic tap for every coin flipped. (Just like with the dice, it's more fun this way!)
            playHaptics(engine: engine, intensity: 0.75, sharpness: 0.75, count: 0.075)
            self.flipCoin()
            self.flipCount += 1
            if (flipCount == numCoins) {
                timer.invalidate(); self.flipCount = 0
                addHistoryEntry(settingsData: settingsData, results: "H: \(headsCount), T: \(tailsCount)", mode: "Coin Mode")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    Spacer()
                    Text("Heads: \(headsCount)")
                    // This code is to make the text showing the random number as big as possible while fitting the screen, fitting above
                    // the buttons, and not truncating.
                        .maxSizeText()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.2, alignment: .center)
                        .contextMenu {
                            Button(action: {
                                copyToClipboard(item: "Heads: \(headsCount)")
                            }) {
                                Text("Copy")
                                Image(systemName: "document.on.document")
                            }
                        }
                    Text("Tails: \(tailsCount)")
                    // This code is to make the text showing the random number as big as possible while fitting the screen, fitting above
                    // the buttons, and not truncating.
                        .maxSizeText()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.2, alignment: .center)
                        .contextMenu {
                            Button(action: {
                                copyToClipboard(item: "Tails: \(tailsCount)")
                            }) {
                                Text("Copy")
                                Image(systemName: "document.on.document")
                            }
                        }
                    Spacer()
                }
                Spacer()
                VStack() {
                    Text("Total Coins Flipped: \(coinCount)")
                        .font(.headline)
                    HStack() {
                        Text("Number of coins")
                        Picker("Number of coins", selection: $numCoins){
                            ForEach(1...50, id: \.self) { index in
                                Text("\(index)").tag(index)
                            }
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.075)
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
                        flipCoins()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Flip a coin")
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.2)
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Reset coin flips")
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
            .onAppear { prepareHaptics(engine: &engine) }
            .navigationTitle("Coins")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CoinMode()
}
