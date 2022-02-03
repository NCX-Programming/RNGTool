//
//  CardMode.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 1/31/22.
//

import SwiftUI

struct CardMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var randomNumbers = [0]
    @State private var showCards = false
    @State private var numOfCards = 1
    @State private var confirmReset = false
    @State private var cardImages = [String]()
    
    func resetGen() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
            showCards = false
        }
        numOfCards = 1
        randomNumbers.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
        ScrollView{
            VStack(alignment: .leading) {
                if(showCards){
                    ZStack(){
                        ForEach(0..<numOfCards, id: \.self) { index in
                            Image(cardImages[index]).resizable()
                                .frame(width: 96, height: 128)
                                .offset(x: CGFloat((geometry.size.width * 0.075) * CGFloat(index)), y: 0)
                        }
                    }
                }
            }
            .padding(.trailing, CGFloat((geometry.size.width * 0.075) * CGFloat((numOfCards - 1))))
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
            }
            Button(action: {
                randomNumbers.removeAll()
                for _ in 0..<numOfCards{
                    randomNumbers.append(Int.random(in: 1...13))
                }
                if(settingsData.useFaces){
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
                else{
                    for n in 0..<numOfCards{
                        cardImages[n] = "c\(randomNumbers[n])"
                    }
                }
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)){
                    showCards = true
                }
            }) {
                Image(systemName: "play.fill")
            }
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.primary)
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
