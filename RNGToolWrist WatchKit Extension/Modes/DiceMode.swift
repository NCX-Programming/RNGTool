//
//  DiceMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI
import WatchKit

struct DiceMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfDice = 1
    @State private var confirmReset = false
    @State private var randomNumbers = [0]
    @State private var diceImages = ["d1"]
    @State private var rollCount = 0
    @State private var showRollHint = true
    
    func resetGen() {
        numOfDice = 1
        randomNumbers.removeAll()
        diceImages[0] = "d1"
        confirmReset = false
    }
    
    func roll() {
        randomNumbers.removeAll()
        for _ in 1..<numOfDice+1{
            randomNumbers.append(Int.random(in: 1...6))
        }
        for n in 0..<randomNumbers.count{
            if(numOfDice>n) {diceImages[n]="d\(randomNumbers[n])"}
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            HStack() {
                ForEach(0..<numOfDice, id: \.self) { index in
                  Image(diceImages[index])
                    .resizable()
                    .frame(width: (geometry.size.width / 2.5) - 10, height: (geometry.size.width / 2.5) - 10)
                }
            }
            .onTapGesture {
                WKInterfaceDevice.current().play(.click)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    self.showRollHint = false
                }
                if(settingsData.playAnimations && !reduceMotion && rollCount == 0) {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        self.roll()
                        self.rollCount += 1
                        if(rollCount == 10) { timer.invalidate(); self.rollCount = 0 }
                    }
                }
                else { self.roll() }
            }
            if(showRollHint && settingsData.showModeHints) {
                Text("Tap dice to roll")
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .center) {
                // The seemingly unrelated code below is together because they must have the same max value
                Picker("", selection: $numOfDice){
                    ForEach(1...2, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .onAppear{
                    for _ in 1...2{
                        diceImages.append("d1")
                    }
                }
                .frame(width: geometry.size.width / 4, height: geometry.size.height / 2.5)
                Text("Number of Dice")
                    .padding(.top, 10)
            }
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
        }
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode().environmentObject(SettingsData())
    }
}
