//
//  MarbleMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI

struct MarbleMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfMarbles = 1
    @State private var rollCount = 0
    @State private var randomNumbers = [0]
    @State private var randomLetterStr = ""
    @State private var randomLetters = [String]()
    @State private var confirmReset = false
    @State private var showRollHint = true
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        randomLetterStr = ""
        numOfMarbles = 1
        for index in 0..<randomNumbers.count {
            randomNumbers[index] = 0
        }
        randomLetters[0] = "A"
        confirmReset = false
    }
    
    func saveHistory() {
        if(settingsData.historyTable.count == 50) { settingsData.historyTable.remove(at: 0) }
        var copyString = "\(randomLetters)"
        copyString.removeAll(where: { removeCharacters.contains($0) } )
        self.settingsData.historyTable.append(HistoryTable(modeUsed: "Marble Mode", numbers: copyString))
    }
    
    func roll() {
        randomLetters.removeAll()
        for index in 0...4{
            randomNumbers[index] = Int.random(in: 0...25)
        }
        for n in 0..<randomNumbers.count{
            if(numOfMarbles > n) { randomLetters.append("\(letters[randomNumbers[n]])") }
        }
        randomLetterStr = "Your random letter(s): \(randomLetters)"
        randomLetterStr.removeAll(where: { removeCharacters.contains($0) } )
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView {
            HStack(){
                ForEach(0..<numOfMarbles, id: \.self) { index in
                    ZStack() {
                        Text("\(letters[randomNumbers[index]])")
                            .font(.title)
                        Circle()
                            .stroke(Color.primary, lineWidth: 3)
                    }
                    .frame(width: (geometry.size.width / 5) - 10, height: (geometry.size.width / 5) - 10)
                }
            }
            .padding(.top, 10)
            .contextMenu {
                Button(action: {
                    var randomLetterCopyStr = "\(randomLetters)"
                    randomLetterCopyStr.removeAll(where: { removeCharacters.contains($0) } )
                    copyToClipboard(item: "\(randomLetterCopyStr)")
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
            .onTapGesture {
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    self.showRollHint = false
                }
                if(settingsData.showMarbleAnimation && !reduceMotion) {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        self.roll()
                        self.rollCount += 1
                        if(rollCount == 10) {
                            timer.invalidate(); self.rollCount = 0
                            self.saveHistory()
                        }
                    }
                }
                else { self.roll(); self.saveHistory() }
            }
            Text(randomLetterStr)
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.5))
                .padding(.bottom, 5)
            if(showRollHint && settingsData.showModeHints) {
                Text("Tap dice to roll")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            Text("Number of marbles")
                .font(.title3)
            // The seemingly unrelated code below is together because they must have the same max value
            Picker("Number of marbles", selection: $numOfMarbles){
                ForEach(1...5, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            .pickerStyle(.segmented)
            .onAppear{
                for _ in 1...5{
                    randomNumbers.append(0)
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
        .padding(.horizontal, 3)
        .navigationTitle("Marbles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode().environmentObject(SettingsData())
    }
}
