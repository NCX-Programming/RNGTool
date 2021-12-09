//
//  CardMode.swift
//  RNGTool
//
//  Created by Campbell on 9/5/21.
//

import SwiftUI

struct CardMode: View {
    @AppStorage("confirmGenResets") private var confirmGenResets = true
    @AppStorage("showPoints") private var showPoints = false
    @AppStorage("aceValue") private var aceValue = 1
    @AppStorage("useFaces") private var useFaces = true
    @State private var randomNumberStr = ""
    @State private var randomNumbers = [0]
    @State private var pointValueStr = ""
    @State private var pointValues = [0]
    @State private var showCards = false
    @State private var numOfCards = 1
    @State private var confirmReset = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var cardImages = [String]()
    
    func resetGen() {
        withAnimation (.easeInOut(duration: 0.5)) {
            randomNumberStr = ""
            pointValueStr = ""
            showCards = false
        }
        numOfCards = 1
        randomNumbers.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Group {
                    Text("Card Mode")
                        .font(.title)
                    Text("Generate multiple numbers using cards")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Divider()
                }
                Group {
                    Text("Number of cards")
                        .font(.title3)
                    // The seemingly unrelated code below is together because they must have the same max value
                    Picker("", selection: $numOfCards){
                        ForEach(1..<8, id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                    .frame(width: 250)
                    .onAppear{
                        for _ in 1..<8{
                            cardImages.append("c1")
                        }
                    }
                }
                Divider()
                HStack() {
                    Button(action: {
                        randomNumbers.removeAll()
                        for _ in 0..<numOfCards{
                            randomNumbers.append(Int.random(in: 1..<14))
                        }
                        withAnimation (.easeInOut(duration: 0.5)) {
                            self.randomNumberStr = "Your random number(s): \(randomNumbers)"
                            randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                        }
                        if(showPoints){
                            pointValues.removeAll()
                            for n in 0..<numOfCards{
                                if(randomNumbers[n]==1){
                                    pointValues.append(aceValue)
                                }
                                else if(randomNumbers[n]>1 && randomNumbers[n]<11){
                                    pointValues.append(randomNumbers[n])
                                }
                                else{
                                    pointValues.append(10)
                                }
                            }
                            withAnimation (.easeInOut(duration: 0.5)) {
                                self.pointValueStr = "Point value(s): \(pointValues)"
                                pointValueStr.removeAll(where: { removeCharacters.contains($0) } )
                            }
                        }
                        else{
                            withAnimation (.easeInOut(duration: 0.5)){
                                self.pointValueStr = ""
                            }
                        }
                        if(useFaces){
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
                        else{
                            for n in 0..<numOfCards{
                                cardImages[n] = "c\(randomNumbers[n])"
                            }
                        }
                        withAnimation(.easeInOut(duration: 0.5)){
                            showCards = true
                        }
                    }) {
                        Image(systemName: "play.fill")
                    }
                    Button(action:{
                        if(confirmGenResets){
                            confirmReset = true
                        }
                        else {
                            resetGen()
                        }
                    }) {
                        Image(systemName: "clear.fill")
                    }
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
                }
                if(showCards) {
                    Divider()
                }
                Group {
                    Text(randomNumberStr)
                        .font(.title2)
                    Text(pointValueStr)
                        .font(.title2)
                        .padding(.bottom, 5)
                    if(showCards){
                        Button(action:{
                            copyToClipboard(item: "\(randomNumbers)")
                        }) {
                            Image(systemName: "doc.on.doc.fill")
                        }
                        .padding(.bottom, 10)
                    }
                }
                HStack(){
                    if(showCards){
                        ZStack(){
                            ForEach(0..<numOfCards, id: \.self) { index in
                                Image(cardImages[index]).resizable()
                                    .frame(width: 192, height: 256)
                                    .offset(x: CGFloat(40*index),y: 0)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.leading, 12)
        }
    }
}

struct CardMode_Previews: PreviewProvider {
    static var previews: some View {
        CardMode()
    }
}
