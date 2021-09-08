//
//  CardMode.swift
//  RNGTool
//
//  Created by Campbell on 9/5/21.
//

import SwiftUI

struct CardMode: View {
    @State private var randomNumberStr = ""
    @State private var randomNumbers = [0]
    @State private var pointValueStr = ""
    @State private var pointValues = [0]
    @State private var showCopy = false
    @State private var showCards = false
    @State private var numOfCards = 1
    @State private var useFaces = true
    @State private var confirmReset = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var cardImages = ["c1","c1","c1","c1","c1"]
    @State private var n = 0
    @State private var nn = 0
    @State private var aceValue = 1
    @State private var showPoints = false
    
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
                    Picker("", selection: $numOfCards){
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .frame(width: 250)
                }
                Divider()
                Group{
                    Group{
                        Text("Card type:")
                            .font(.title3)
                        Text("Changes whether the card graphics will only use numbers or will include face cards.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("", selection: $useFaces) {
                            Text("Faces").tag(true)
                            Text("Numbers Only").tag(false)
                        }.pickerStyle(RadioGroupPickerStyle())
                    }
                    Group{
                        Text("Ace value:")
                            .font(.title3)
                        Text("Changes whether the Ace card is worth 1 or 11 points. This setting is ignored if \"Show card point values\" is off.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Picker("", selection: $aceValue){
                            Text("1 Point").tag(1)
                            Text("11 Points").tag(11)
                        }.pickerStyle(RadioGroupPickerStyle())
                        .disabled(!showPoints)
                    }
                    Toggle(isOn: $showPoints) {
                        Text("Show card point values")
                    }
                }
                Divider()
                HStack() {
                    Button(action: {
                        showCopy = true
                        randomNumbers.removeAll()
                        for _ in 1..<numOfCards+1{
                            randomNumbers.append(Int.random(in: 1..<14))
                        }
                        withAnimation (.easeInOut(duration: 0.5)) {
                            self.randomNumberStr = "Your random number(s): \(randomNumbers)"
                            randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                        }
                        if(showPoints==true){
                            nn = 0
                            pointValues.removeAll()
                            for nn in 0..<numOfCards{
                                if(randomNumbers[nn]==1){
                                    pointValues.append(aceValue)
                                }
                                else if(randomNumbers[nn]>1 && randomNumbers[nn]<11){
                                    pointValues.append(randomNumbers[nn])
                                }
                                else if(randomNumbers[nn]>10){
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
                        if(useFaces==true){
                            n = 0
                            showCards = true
                            for n in 0..<numOfCards{
                                if(randomNumbers[n]==1){
                                    cardImages[n] = "cA"
                                }
                                else if(randomNumbers[n]==11){
                                    cardImages[n] = "cJ"
                                }
                                else if(randomNumbers[n]==12){
                                    cardImages[n] = "cQ"
                                }
                                else if(randomNumbers[n]==13){
                                    cardImages[n] = "cK"
                                }
                                else{
                                    cardImages[n] = "c\(randomNumbers[n])"
                                }
                            }
                        }
                        else{
                            n = 0
                            showCards = true
                            for n in 0..<numOfCards{
                                cardImages[n] = "c\(randomNumbers[n])"
                            }
                        }
                    }) {
                        Image(systemName: "play.fill")
                    }
                    Button(action:{
                        confirmReset = true
                    }) {
                        Image(systemName: "clear.fill")
                    }
                    .help("Reset custom values and output")
                    .sheet(isPresented: $confirmReset) {
                        Text("Are you sure that you want to reset the generator?")
                            .font(.title3)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        Button(action:{
                            numOfCards = 1
                            randomNumbers.removeAll()
                            withAnimation (.easeInOut(duration: 0.5)) {
                                randomNumberStr = ""
                                pointValueStr = ""
                            }
                            confirmReset = false
                            showCopy = false
                            showCards = false
                        }) {
                            Text("Reset")
                        }
                        .foregroundColor(.red)
                        Button(action:{
                            confirmReset = false
                        }) {
                            Text("Cancel")
                        }
                        .padding(.bottom, 10)
                    }
                }
                Divider()
                Group {
                    Text(randomNumberStr)
                        .font(.title2)
                    Text(pointValueStr)
                        .font(.title2)
                        .padding(.bottom, 5)
                    if(showCopy){
                        Button(action:{
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                            pasteboard.setString("\(randomNumbers)", forType: NSPasteboard.PasteboardType.string)
                            var clipboardItems: [String] = []
                            for element in pasteboard.pasteboardItems! {
                                if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                                    clipboardItems.append(str)
                                }
                            }
                        }) {
                            Image(systemName: "doc.on.doc.fill")
                        }
                        .padding(.bottom, 10)
                    }
                }
                HStack(){
                    ZStack() {
                        if(showCards){
                            Image(cardImages[0]).resizable()
                                .frame(width: 192, height: 256)
                            if(numOfCards>1){
                                Image(cardImages[1]).resizable()
                                    .frame(width: 192, height: 256)
                                    .offset(x: 40,y: 0)
                                if(numOfCards>2){
                                    Image(cardImages[2]).resizable()
                                        .frame(width: 192, height: 256)
                                        .offset(x: 80,y: 0)
                                    if(numOfCards>3){
                                        Image(cardImages[3]).resizable()
                                            .frame(width: 192, height: 256)
                                            .offset(x: 120,y: 0)
                                        if(numOfCards>4){
                                            Image(cardImages[4]).resizable()
                                                .frame(width: 192, height: 256)
                                                .offset(x: 160,y: 0)
                                        }
                                    }
                                }
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
