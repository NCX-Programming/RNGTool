//
//  CardMode.swift
//  RNGTool
//
//  Created by Campbell on 9/5/21.
//

import SwiftUI

struct CardMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var randomNumberStr = ""
    @State private var randomNumbers = [0]
    @State private var pointValueStr = ""
    @State private var pointValues = [0]
    @State private var numOfCards = 1
    @State private var cardsToDisplay = 1
    @State private var confirmReset = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var cardImages = ["c1"]
    @State private var drawCount = 0
    
    func resetGen() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            randomNumberStr = ""
            pointValueStr = ""
        }
        if(settingsData.showCardAnimation && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if(cardsToDisplay == 1) { timer.invalidate() }
                if(cardsToDisplay > 1) { cardsToDisplay -= 1 }
            }
        }
        else { cardsToDisplay = 1 }
        numOfCards = 1
        randomNumbers.removeAll()
        cardImages[0] = "c1"
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Number of cards")
                        .font(.title3)
                    // The seemingly unrelated code below is together because they must have the same max value
                    Picker("", selection: $numOfCards) {
                        ForEach(1...7, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 250)
                    .onAppear {
                        for _ in 1...7{
                            cardImages.append("c1")
                        }
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
                .help("Reset custom values and output")
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
                Text(pointValueStr)
                    .font(.title2)
                    .padding(.bottom, 5)
                HStack(){
                    ZStack(){
                        ForEach(0..<cardsToDisplay, id: \.self) { index in
                            Image(cardImages[index]).resizable()
                                .frame(width: 192, height: 256)
                                .offset(x: CGFloat(40*index),y: 0)
                        }
                    }
                }
                .contextMenu {
                    Button(action: {
                        copyToClipboard(item: randomNumberStr)
                    }) {
                        Text("Copy")
                    }
                }
                .onTapGesture {
                    randomNumbers.removeAll()
                    for _ in 0..<numOfCards {
                        randomNumbers.append(Int.random(in: 1...13))
                    }
                    self.randomNumberStr = "\(randomNumbers)"
                    randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                    if(settingsData.showPoints) {
                        pointValues.removeAll()
                        for n in 0..<numOfCards {
                            if(randomNumbers[n] == 1) {
                                pointValues.append(settingsData.aceValue)
                            }
                            else if(randomNumbers[n] > 1 && randomNumbers[n] < 11) {
                                pointValues.append(randomNumbers[n])
                            }
                            else {
                                pointValues.append(10)
                            }
                        }
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                            self.pointValueStr = "Point value(s): \(pointValues)"
                            pointValueStr.removeAll(where: { removeCharacters.contains($0) } )
                        }
                    }
                    else {
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                            self.pointValueStr = ""
                        }
                    }
                    cardsToDisplay = 1
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
                    if(settingsData.showCardAnimation && !reduceMotion) {
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            if(drawCount == numOfCards) { timer.invalidate(); self.drawCount = 0 }
                            if(cardsToDisplay < numOfCards) { cardsToDisplay += 1 }
                            self.drawCount += 1
                        }
                    }
                    else { cardsToDisplay = numOfCards }
                    if(settingsData.historyTable.count == 50) { settingsData.historyTable.remove(at: 0) }
                    self.settingsData.historyTable.append(HistoryTable(modeUsed: "Card Mode", numbers: randomNumberStr))
                }
            }
            .padding(.leading, 12)
        }
        }
        .navigationTitle("Cards")
    }
}

struct CardMode_Previews: PreviewProvider {
    static var previews: some View {
        CardMode().environmentObject(SettingsData())
    }
}
