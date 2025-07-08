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
    @State private var randomNumbers: [Int] = [0]
    @State private var pointValueStr: String = ""
    @State private var pointValues: [Int] = [0]
    @State private var numCards: Int = 1
    @State private var cardsToDisplay: Int = 1
    @State private var confirmReset: Bool = false
    @State private var cardImages: [String] = Array(repeating: "c1", count: 7)
    @State private var showDrawHint: Bool = true
    @State private var drawCount: Int = 0
    @State private var timer: Timer?
    
    func clearVars() {
        numCards = 1
        randomNumbers.removeAll()
        cardImages = Array(repeating: "c1", count: 7)
        confirmReset = false
    }
    
    func resetGen() {
        timer?.invalidate()
        pointValueStr = ""
        if (settingsData.playAnimations && !reduceMotion) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { timer in
                if(cardsToDisplay == 1) {
                    timer.invalidate()
                    clearVars()
                }
                if(cardsToDisplay > 1) { cardsToDisplay -= 1 }
            }
        }
        else {
            cardsToDisplay = 1
            clearVars()
        }
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
        if (timer?.isValid == true) {
            return
        }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
            self.showDrawHint = false
        }
        randomNumbers.removeAll()
        for _ in 1...7 {
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
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                // Play a single haptic tap for every draw in the animation. (It's more fun this way!)
                playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.1)
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
                                    .offset(x: CGFloat((geometry.size.width * 0.085) * CGFloat(index)), y: 0)
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
                    .padding(.trailing, CGFloat((geometry.size.width * 0.085) * CGFloat((cardsToDisplay - 1))))
                    Text(pointValueStr)
                        .animation(.linear, value: pointValueStr) // Enables the use of .contentTransition()
                        .apply {
                            if #available(iOS 16.0, *) {
                                $0.contentTransition(.numericText())
                            }
                            else {
                                $0.animation(reduceMotion ? .none : .easeInOut(duration: 0.25), value: pointValueStr)
                            }
                        }
                        .padding(.bottom, 5)
                    Spacer()
                }
                Spacer()
                VStack() {
                    if (showDrawHint && settingsData.showModeHints) {
                        Text("Tap the card to draw a hand")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Text("Number of cards")
                    Picker("Number of cards", selection: $numCards){
                        ForEach(1...7, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, geometry.size.width * 0.075)
                    .padding(.bottom, 10)
                    Button(action:{
                        drawCards()
                    }) {
                        Image(systemName: "play.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(LargeSquareAccentButton())
                    .help("Draw a hand")
                    Button(action:{
                        playHaptics(engine: engine, intensity: 1, sharpness: 0.75, count: 0.2)
                        if (settingsData.confirmGenResets) { confirmReset = true } else { resetGen() }
                    }) {
                        Image(systemName: "clear.fill")
                            .padding(.horizontal, geometry.size.width * 0.4)
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
        .onAppear { prepareHaptics(engine: &engine) }
        .navigationTitle("Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CardMode_Previews: PreviewProvider {
    static var previews: some View {
        CardMode().environmentObject(SettingsData())
    }
}
