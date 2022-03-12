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
    @State private var numOfDice = 1
    @State private var confirmReset = false
    @State private var randomNumbers = [0]
    @State private var randomNumberStr = ""
    @State private var numsInArray = 0
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var diceImages = ["d1"]
    @State private var rollCount = 0
    @State private var showRollHint = true
    
    func resetGen() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            randomNumberStr = ""
        }
        numOfDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    func roll() {
        randomNumbers.removeAll()
        for _ in 1...numOfDice {
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count {
            if(numOfDice > n) { diceImages[n] = "d\(randomNumbers[n])" }
        }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            self.randomNumberStr = "Your random number(s): \(randomNumbers)"
            randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            VStack(alignment: .leading) {
                HStack(){
                    ForEach(0..<numOfDice, id: \.self) { index in
                      Image(diceImages[index])
                        .resizable()
                        .frame(width: geometry.size.width / 9, height: geometry.size.width / 9)
                    }
                }
                .padding(.top, 10)
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Text("Copy")
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
                            if(rollCount == 10) { timer.invalidate(); self.rollCount = 0 }
                        }
                    }
                    else { self.roll() }
                    if(settingsData.historyTable.count == 50) { settingsData.historyTable.remove(at: 0) }
                    var copyString = "\(randomNumbers)"
                    copyString.removeAll(where: { removeCharacters.contains($0) } )
                    self.settingsData.historyTable.append(HistoryTable(modeUsed: "Dice Mode", numbers: copyString))
                }
                if(showRollHint && settingsData.showModeHints) {
                    Text("Click the dice to roll")
                        .foregroundColor(.secondary)
                }
                Text(randomNumberStr)
                    .font(.title2)
                    .padding(.bottom, 5)
                    .contextMenu {
                        Button(action: {
                            var copyString = "\(randomNumbers)"
                            copyString.removeAll(where: { removeCharacters.contains($0) } )
                            copyToClipboard(item: copyString)
                        }) {
                            Text("Copy")
                        }
                    }
                Text("Number of dice")
                    .font(.title3)
                // The seemingly unrelated code below is together because they must have the same max value
                Picker("", selection: $numOfDice){
                    ForEach(1...6, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .frame(width: 200)
                .onAppear{
                    for _ in 1...6{
                        diceImages.append("d1")
                    }
                }
                Divider()
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
                .help("Reset number of dice and output")
                .foregroundColor(.red)
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
            .padding(.leading, 12)
        }
        }
        .navigationTitle("Dice")
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
