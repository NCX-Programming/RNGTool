//
//  CardMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI
import CoreHaptics

struct CardMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var engine: CHHapticEngine?
    @State private var randomNumbers = [0]
    @State private var pointValueStr = ""
    @State private var pointValues = [0]
    @State private var numOfCards = 1
    @State private var cardsToDisplay = 1
    @State private var confirmReset = false
    @State private var cardImages = ["c1"]
    @State private var showDrawHint = true
    @State private var drawCount = 0
    
    func resetGen() {
        pointValueStr = ""
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
    
    func getCards() {
        for n in 0..<numOfCards{
            switch randomNumbers[n]{
            case 1:
                cardImages[n]="cA"
            case 11:
                cardImages[n]="cJ"
            case 12:
                cardImages[n]="cQ"
            case 13:
                cardImages[n]="cK"
            default:
                cardImages[n]="c\(randomNumbers[n])"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            Group {
                Text("Number of cards")
                    .font(.title3)
                // The seemingly unrelated code below is together because they must have the same max value
                Picker("", selection: $numOfCards){
                    ForEach(1...7, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .onAppear{
                    for _ in 1...7{
                        cardImages.append("c1")
                    }
                }
            }
            Divider()
            Button(action:{
                playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.1)
                if(settingsData.confirmGenResets){
                    confirmReset = true
                }
                else { resetGen() }
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
            if(showDrawHint && settingsData.showModeHints) {
                Text("Tap cards to draw a hand")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            Text(pointValueStr)
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.5))
                .padding(.bottom, 5)
            VStack(alignment: .leading) {
                ZStack(){
                    ForEach(0..<cardsToDisplay, id: \.self) { index in
                        Image(cardImages[index]).resizable()
                            .frame(width: 192, height: 256)
                            .offset(x: CGFloat((geometry.size.width*0.075)*CGFloat(index)),y: 0)
                    }
                }
            }
            .contextMenu {
                Button(action: {
                    copyToClipboard(item: "\(randomNumbers)")
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
            .onTapGesture {
                if(drawCount == 0) { playHaptics(engine: engine, intensity: 1, sharpness: 0.5, count: 0.2) }
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    self.showDrawHint = false
                }
                randomNumbers.removeAll()
                for _ in 1...7{
                    randomNumbers.append(Int.random(in: 1...13))
                }
                if(settingsData.showPoints){
                    pointValues.removeAll()
                    for n in 0..<numOfCards {
                        if(randomNumbers[n] == 1) {
                            pointValues.append(settingsData.aceValue)
                        }
                        else if(randomNumbers[n] > 1 && randomNumbers[n] < 11) {
                            pointValues.append(randomNumbers[n])
                        }
                        else{
                            pointValues.append(10)
                        }
                    }
                    self.pointValueStr = "Point value(s): \(pointValues)"
                    pointValueStr.removeAll(where: { removeCharacters.contains($0) } )
                }
                else{
                    self.pointValueStr = ""
                }
                cardsToDisplay = 1
                self.getCards()
                if(settingsData.showCardAnimation && !reduceMotion) {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if(cardsToDisplay < numOfCards) { cardsToDisplay += 1 }
                        self.drawCount += 1
                        if(drawCount == numOfCards) { timer.invalidate(); self.drawCount = 0 }
                    }
                }
                else { cardsToDisplay = numOfCards }
                addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Card Mode")
            }
            .padding(.trailing, CGFloat((geometry.size.width * 0.075) * CGFloat((cardsToDisplay - 1))))
            .onAppear { prepareHaptics(engine: &engine) }
        }
        }
        .padding(.horizontal, 3)
        .navigationTitle("Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardMode_Previews: PreviewProvider {
    static var previews: some View {
        CardMode().environmentObject(SettingsData())
    }
}
