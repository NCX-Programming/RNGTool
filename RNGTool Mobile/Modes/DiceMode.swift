//
//  DiceMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfDice = 1
    @State private var confirmReset = false
    @State private var randomNumbers = [0]
    @State private var randomNumberStr = ""
    @State private var diceImages = ["d1"]
    @State private var rollCount = 0
    @State private var showRollHint = true
    
    func resetGen() {
        randomNumberStr = ""
        numOfDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    func roll() {
        randomNumbers.removeAll()
        for _ in 1...numOfDice{
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count{
            if(numOfDice > n) { diceImages[n] = "d\(randomNumbers[n])" }
        }
        self.randomNumberStr = "Your random number(s): \(randomNumbers)"
        randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            Group {
                HStack(){
                    ForEach(0..<numOfDice, id: \.self) { index in
                      Image(diceImages[index])
                        .resizable()
                        .frame(width: (geometry.size.width / 6) - 10, height: (geometry.size.width / 6) - 10)
                    }
                }
                .padding(.top, 10)
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
                .onTapGesture {
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                        self.showRollHint = false
                    }
                    if(settingsData.showDiceAnimation && !reduceMotion) {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            self.roll()
                            self.rollCount += 1
                            if(rollCount == 10) {
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
                Text(randomNumberStr)
                    .animation(reduceMotion ? .none : .easeInOut(duration: 0.5))
                    .padding(.bottom, 5)
            }
            if(showRollHint && settingsData.showModeHints) {
                Text("Tap dice to roll")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            Text("Number of dice")
                .font(.title3)
            // The seemingly unrelated code below is together because they must have the same max value
            Picker("Number of dice", selection: $numOfDice){
                ForEach(1...6, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            .pickerStyle(.segmented)
            .onAppear{
                for _ in 1...6{
                    diceImages.append("d1")
                }
            }
            Divider()
            HStack() {
                Button(action:{
                    if(settingsData.confirmGenResets){
                        confirmReset = true
                    }
                    else {
                        resetGen()
                    }
                }) {
                    Image(systemName: "clear.fill")
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
                .help("Reset custom values and output")
                .alert(isPresented: $confirmReset){
                    Alert(
                        title: Text("Confirm Reset"),
                        message: Text("Are you sure you want to reset the generator? This cannot be undone."),
                        primaryButton: .default(Text("Confirm")){
                            resetGen()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        }
        .padding(.horizontal, 3)
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
