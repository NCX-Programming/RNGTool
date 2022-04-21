//
//  MarbleMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI
import WatchKit

struct MarbleMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var numOfMarbles = 1
    @State private var randomNumbers = [0]
    @State private var randomLetters = [String]()
    @State private var confirmReset = false
    @State private var showRollHint = true
    @State private var rollCount = 0
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        numOfMarbles = 1
        for index in 0..<randomNumbers.count {
            randomNumbers[index] = 0
        }
        randomLetters[0] = "A"
        confirmReset = false
    }
    
    func roll() {
        randomLetters.removeAll()
        for index in 0...2 {
            randomNumbers[index] = Int.random(in: 0...25)
        }
        for i in 0..<numOfMarbles {
            randomLetters.append(letters[randomNumbers[i]])
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView {
            HStack(){
                ForEach(0..<numOfMarbles, id: \.self) { index in
                    ZStack() {
                        Text("\(letters[randomNumbers[index]])")
                            .font(.title3)
                        Circle()
                            .stroke(Color.primary, lineWidth: 3)
                    }
                    .frame(width: (geometry.size.width / 3) - 10, height: (geometry.size.width / 3) - 10)
                }
            }
            .padding(.top, 4)
            .onTapGesture {
                WKInterfaceDevice.current().play(.click)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    self.showRollHint = false
                }
                if(settingsData.showMarbleAnimation && !reduceMotion) {
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
                Picker("", selection: $numOfMarbles){
                    ForEach(1...3, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .frame(width: geometry.size.width / 4, height: geometry.size.height / 2.5)
                .onAppear{
                    for _ in 1...3 {
                        randomNumbers.append(0)
                    }
                }
                Text("Number of Marbles")
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
        .navigationTitle("Marbles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode().environmentObject(SettingsData())
    }
}
