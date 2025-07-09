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
    @State private var randomNumbers: [Int] = [0]
    @State private var showCards: Bool = false
    @State private var numCards: Int = 1
    @State private var cardsToDisplay: Int = 1
    @State private var confirmReset: Bool = false
    @State private var cardImages: [String] = Array(repeating: "c1", count: 3)
    @State private var drawCount: Int = 0
    @State private var showDrawHint: Bool = true
    @State private var timer: Timer?
    @State private var drawTask: Task<Void, Never>? = nil
    
    func resetGen() {
        timer?.invalidate()
        drawTask?.cancel()
        drawTask = nil
        numCards = 1
        cardsToDisplay = 1
        cardImages = Array(repeating: "c1", count: 3)
        confirmReset = false
    }
    
    func getCards() {
        for n in 0..<numCards{
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
    
    func drawCards() {
        guard drawTask == nil else { return }
        drawTask = Task {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                self.showDrawHint = false
            }
            randomNumbers = (0..<numCards).map { _ in Int.random(in: 1...13) }
            cardsToDisplay = 1
            self.getCards()
            if settingsData.playAnimations && !reduceMotion {
                for _ in 0..<numCards {
                    if Task.isCancelled { return }
                    try? await Task.sleep(nanoseconds: 100_000_000) // Why does this have to be nanoseconds? It's 0.1s.
                    await MainActor.run {
                        if(cardsToDisplay < numCards) { cardsToDisplay += 1 }
                        self.drawCount += 1
                        if(drawCount == numCards) { self.drawCount = 0 }
                    }
                }
            } else { cardsToDisplay = numCards }
            drawTask = nil
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(){
                        ForEach(0..<cardsToDisplay, id: \.self) { index in
                            Image(cardImages[index]).resizable()
                                .frame(width: 90, height: 126)
                                .offset(x: CGFloat((geometry.size.width * 0.15) * CGFloat(index)), y: 0)
                        }
                    }
                }
                .padding(.trailing, CGFloat((geometry.size.width * 0.15) * CGFloat((cardsToDisplay - 1))))
                .onTapGesture { drawCards() }
                if(showDrawHint && settingsData.showModeHints) {
                    Text("Tap cards to draw")
                        .foregroundColor(.secondary)
                }
                Picker("Number of Cards", selection: $numCards){
                    ForEach(1...3, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .frame(width: geometry.size.width - 15, height: geometry.size.height / 2.5)
                .disabled(drawTask != nil)
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
                .alert("Confirm Reset", isPresented: $confirmReset, actions: {
                    Button("Confirm", role: .destructive) {
                        resetGen()
                    }
                }, message: {
                    Text("Are you sure you want to reset the generator?")
                })
            }
            .frame(width: geometry.size.width)
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
