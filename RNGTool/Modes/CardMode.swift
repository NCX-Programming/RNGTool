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
    @State private var randomNumbers: [Int] = [0]
    @State private var pointValueStr: String = ""
    @State private var pointValues: [Int] = [0]
    @State private var numCards: Int = 1
    @State private var cardsToDisplay: Int = 1
    @State private var confirmReset: Bool = false
    @State private var cardImages: [String] = Array(repeating: "c1", count: 12)
    @State private var showDrawHint: Bool = true
    @State private var drawCount: Int = 0
    
    func resetGen() {
        pointValueStr = ""
        if(settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if(cardsToDisplay == 1) { timer.invalidate() }
                if(cardsToDisplay > 1) { cardsToDisplay -= 1 }
            }
        }
        else { cardsToDisplay = 1 }
        numCards = 1
        randomNumbers.removeAll()
        cardImages[0] = "c1"
        confirmReset = false
    }
    
    func getCards() {
        for n in 0..<numCards {
            switch randomNumbers[n] {
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
    
    func drawCards() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            self.showDrawHint = false
        }
        randomNumbers.removeAll()
        for _ in 1...12 {
            randomNumbers.append(Int.random(in: 1...13))
        }
        if(settingsData.showPoints) {
            pointValues.removeAll()
            for n in 0..<numCards {
                if (randomNumbers[n] == 1) {
                    pointValues.append(settingsData.aceValue)
                }
                else if (randomNumbers[n] > 1 && randomNumbers[n] < 11) {
                    pointValues.append(randomNumbers[n])
                }
                else {
                    pointValues.append(10)
                }
            }
            self.pointValueStr = "Point value(s): \(pointValues)"
            pointValueStr.removeAll(where: { removeCharacters.contains($0) } )
        }
        else {
            self.pointValueStr = ""
        }
        cardsToDisplay = 1
        self.getCards()
        if(settingsData.playAnimations && !reduceMotion) {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if(cardsToDisplay < numCards) { cardsToDisplay += 1 }
                self.drawCount += 1
                if(drawCount == numCards) { timer.invalidate(); self.drawCount = 0 }
            }
        }
        else { cardsToDisplay = numCards }
        addHistoryEntry(settingsData: settingsData, results: "\(randomNumbers)", mode: "Card Mode")
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                VStack() {
                    Spacer()
                    VStack(alignment: .leading) {
                        ZStack(){
                            ForEach(0..<cardsToDisplay, id: \.self) { index in
                                Image(cardImages[index]).resizable()
                                    .frame(width: 180, height: 252)
                                    .offset(x: CGFloat((geometry.size.width * 0.075) * CGFloat(index)), y: 0)
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
                    .onTapGesture { drawCards() }
                    .padding(.trailing, CGFloat((geometry.size.width * 0.075) * CGFloat((cardsToDisplay - 1))))
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.65)
                    Text(pointValueStr)
                        .animation(.linear, value: pointValueStr) // Enables the use of .contentTransition()
                        .apply {
                            if #available(macOS 13.0, *) {
                                $0.contentTransition(.numericText())
                            }
                            else {
                                $0.animation(reduceMotion ? .none : .easeInOut(duration: 0.25), value: pointValueStr)
                            }
                        }
                    Spacer()
                }
                Spacer()
                VStack() {
                    if (showDrawHint && settingsData.showModeHints) {
                        Text("Tap the card to draw a hand")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Picker("Number of cards:", selection: $numCards) {
                        ForEach(1...12, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 300)
                    .padding(.bottom, 10)
                    Button(action:{
                        drawCards()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Draw a hand")
                    Button(action:{
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.2)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Reset drawn hand")
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
        }
        .navigationTitle("Cards")
    }
}

#Preview {
    CardMode().environmentObject(SettingsData())
}
