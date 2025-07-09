//
//  CoinMode.swift
//  RNGTool
//
//  Created by Campbell on 2/25/25.
//

import SwiftUI

struct CoinMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @SceneStorage("CoinMode.coinCount") private var coinCount: Int = 0
    @SceneStorage("CoinMode.headsCount") private var headsCount: Int = 0
    @SceneStorage("CoinMode.tailsCount") private var tailsCount: Int = 0
    @State private var numCoins: Int = 1
    @State private var flipCount: Int = 0
    @State private var confirmReset: Bool = false
    @State private var flipTask: Task<Void, Never>? = nil
    
    func resetGen() {
        flipTask?.cancel()
        flipTask = nil
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
        // No more spam flipping allowed!
        guard flipTask == nil else { return }
        flipTask = Task {
            for _ in 0..<numCoins {
                if Task.isCancelled { return }
                await MainActor.run {
                    self.flipCoin()
                    self.flipCount += 1
                }
                try? await Task.sleep(nanoseconds: 50_000_000) // Why does this have to be nanoseconds? It's 0.05s.
            }
            await MainActor.run {
                addHistoryEntry(settingsData: settingsData, results: "H: \(headsCount), T: \(tailsCount)", mode: "Coin Mode")
                flipCount = 0
                flipTask = nil
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    Spacer()
                    Text("Heads: \(headsCount)")
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
                .onAppear {
                    // Clear out remembered values if we aren't supposed to save them
                    if (settingsData.saveModeStates == false) {
                        coinCount = 0
                        headsCount = 0
                        tailsCount = 0
                    }
                }
                Spacer()
                VStack() {
                    Text("Total Coins Flipped: \(coinCount)")
                        .font(.headline)
                    Picker("Number of coins:", selection: $numCoins){
                        ForEach(1...100, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 300)
                    .padding(.horizontal, geometry.size.width * 0.075)
                    .padding(.bottom, 10)
                    .disabled(flipTask != nil)
                    Button(action:{
                        flipCoins()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Flip a coin")
                    .disabled(flipTask != nil)
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
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
            .navigationTitle("Coins")
        }
    }
}

#Preview {
    CoinMode().environmentObject(SettingsData())
}
