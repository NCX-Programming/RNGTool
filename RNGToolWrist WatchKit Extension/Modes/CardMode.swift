//
//  CardMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI
import WatchKit

struct CardMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var randomNumbers = [0]
    @State private var showCards = false
    @State private var numOfCards = 1
    @State private var cardsToDisplay = 1
    @State private var confirmReset = false
    @State private var cardImages = ["c1"]
    @State private var drawCount = 0
    @State private var showDrawHint = true
    
    func resetGen() {
        numOfCards = 1
        cardsToDisplay = 1
        randomNumbers.removeAll()
        cardImages[0] = "c1"
        confirmReset = false
    }
    
    func getCards() {
        for n in 0..<numOfCards{
            switch randomNumbers[n]{
            case 1:
                cardImages[n] = "cA"
            case 11:
                cardImages[n] = "cJ"
            case 12:
                cardImages[n] = "cQ"
            case 13:
                cardImages[n] = "cK"
            default:
                cardImages[n] = "c\(randomNumbers[n])"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            VStack(alignment: .leading) {
                ZStack(){
                    ForEach(0..<cardsToDisplay, id: \.self) { index in
                        Image(cardImages[index]).resizable()
                            .frame(width: 96, height: 128)
                            .offset(x: CGFloat((geometry.size.width * 0.075) * CGFloat(index)), y: 0)
                    }
                }
            }
            .padding(.trailing, CGFloat((geometry.size.width * 0.075) * CGFloat((cardsToDisplay - 1))))
            .onTapGesture {
                WKInterfaceDevice.current().play(.click)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    self.showDrawHint = false
                }
                randomNumbers.removeAll()
                for _ in 0..<numOfCards{
                    randomNumbers.append(Int.random(in: 1...13))
                }
                cardsToDisplay = 1
                self.getCards()
                if(settingsData.showCardAnimation && !reduceMotion) {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if(drawCount == numOfCards) { timer.invalidate(); self.drawCount = 0 }
                        if(cardsToDisplay < numOfCards) { cardsToDisplay += 1 }
                        self.drawCount += 1
                    }
                }
                else { cardsToDisplay = numOfCards }
            }
            if(showDrawHint && settingsData.showModeHints) {
                Text("Tap cards to draw")
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .center) {
                // The seemingly unrelated code below is together because they must have the same max value
                Picker("", selection: $numOfCards){
                    ForEach(1...3, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .onAppear{
                    for _ in 1...3 {
                        cardImages.append("c1")
                    }
                }
                .frame(width: geometry.size.width / 4, height: geometry.size.height / 2.5)
                Text("Number of Cards")
                    .padding(.top, 12)
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
        .navigationTitle("Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardMode_Previews: PreviewProvider {
    static var previews: some View {
        CardMode().environmentObject(SettingsData())
    }
}
