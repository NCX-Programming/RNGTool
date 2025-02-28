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
    @State private var randomLetters: [String] = Array(repeating: "A", count: 3)
    @State private var confirmReset = false
    @State private var showRollHint = true
    @State private var rollCount = 0
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        numOfMarbles = 1
        randomLetters = Array(repeating: "A", count: 3)
        confirmReset = false
    }
    
    func roll() {
        for i in 0..<numOfMarbles {
            randomLetters[i] = letters[Int.random(in: 0...25)]
        }
    }
    
    func startRoll() {
        WKInterfaceDevice.current().play(.click)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
            showRollHint = false
        }
        if(settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                roll()
                rollCount += 1
                if (rollCount == 10) { timer.invalidate(); rollCount = 0 }
            }
        }
        else { self.roll() }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack(){
                    ForEach(0..<numOfMarbles, id: \.self) { index in
                        ZStack() {
                            Text("\(randomLetters[index])")
                                .font(.title3)
                            Circle()
                                .stroke(Color.primary, lineWidth: 3)
                        }
                        .frame(width: (geometry.size.width / 3) - 10, height: (geometry.size.width / 3) - 10)
                    }
                }
                .padding(.top, 4)
                .onTapGesture { startRoll() }
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
                    .frame(width: geometry.size.width / 3)
                    Text("Number of Marbles")
                }
                .frame(width: geometry.size.width, height: geometry.size.height / 2, alignment: .center)
                Button(action:{
                    if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                }) {
                    Image(systemName: "clear.fill")
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.red)
                .alert("Confirm Reset", isPresented: $confirmReset, actions: {
                    Button("Confirm", role: .destructive) {
                        resetGen()
                    }
                }, message: {
                    Text("Are you sure you want to reset the generator?")
                })
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
