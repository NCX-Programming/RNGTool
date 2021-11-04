//
//  DiceMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct DiceMode: View {
    @AppStorage("confirmGenResets") private var confirmGenResets = true
    @AppStorage("forceSixSides") private var forceSixSides = false
    @AppStorage("allowDiceImages") private var allowDiceImages = true
    @State private var numOfDice = 1
    @State private var numOfSides = 6
    @State private var confirmReset = false
    @State private var randomNumbers = [0]
    @State private var randomNumberStr = ""
    @State private var numsInArray = 0
    @State private var showCopy = false
    @State private var showDice = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var diceImages = ["d1","d1","d1","d1","d1","d1"]
    
    
    func incrementStep() {
        numOfSides += 1
        if numOfSides > 20 {numOfSides = 20}
    }

    func decrementStep() {
        numOfSides -= 1
        if numOfSides < 6 {numOfSides = 6}
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Group {
                    Text("Dice Mode")
                        .font(.title)
                    Text("Generate multiple numbers using dice")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Divider()
                    HStack(){
                        if(showDice && allowDiceImages){
                            Image(diceImages[0]).resizable()
                                .frame(width: 64, height: 64)
                            if(numOfDice>1){
                                Image(diceImages[1]).resizable()
                                    .frame(width: 64, height: 64)
                                if(numOfDice>2){
                                    Image(diceImages[2]).resizable()
                                        .frame(width: 64, height: 64)
                                    if(numOfDice>3){
                                        Image(diceImages[3]).resizable()
                                            .frame(width: 64, height: 64)
                                        if(numOfDice>4){
                                            Image(diceImages[4]).resizable()
                                                .frame(width: 64, height: 64)
                                            if(numOfDice>5){
                                                Image(diceImages[5]).resizable()
                                                    .frame(width: 64, height: 64)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Text(randomNumberStr)
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
                        Divider()
                    }
                }
                Text("Number of dice")
                    .font(.title3)
                Picker("", selection: $numOfDice){
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                    Text("6").tag(6)
                }
                .frame(width: 250)
                Divider()
                Group{
                    Stepper(onIncrement: incrementStep, onDecrement: decrementStep) {
                        Text("Sides on each die: \(numOfSides)")
                            .font(.title3)
                    }
                    .disabled(forceSixSides && allowDiceImages)
                    .help(forceSixSides ? "This option is disabled by \"Force 6 sides per die\" in settings": "")
                    Text("Maximum of 20, minimum of 6. Images are only shown for 6-sided dice.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Divider()
                HStack() {
                    Button(action: {
                        showCopy = true
                        randomNumbers.removeAll()
                        for _ in 1..<numOfDice+1{
                            randomNumbers.append(Int.random(in: 1..<numOfSides+1))
                        }
                        withAnimation (.easeInOut(duration: 0.5)) {
                            self.randomNumberStr = "Your random number(s): \(randomNumbers)"
                            randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                        }
                        if(numOfSides==6){
                            showDice = true
                            diceImages[0] = "d\(randomNumbers[0])"
                            if(numOfDice>1) {diceImages[1] = "d\(randomNumbers[1])"}
                            if(numOfDice>2) {diceImages[2] = "d\(randomNumbers[2])"}
                            if(numOfDice>3) {diceImages[3] = "d\(randomNumbers[3])"}
                            if(numOfDice>4) {diceImages[4] = "d\(randomNumbers[4])"}
                            if(numOfDice>5) {diceImages[5] = "d\(randomNumbers[5])"}
                        }
                        else{
                            showDice = false
                        }
                    }) {
                        Image(systemName: "play.fill")
                    }
                    Button(action:{
                        if(confirmGenResets){
                            confirmReset = true
                        }
                        else {
                            numOfDice = 1
                            numOfSides = 6
                            randomNumbers.removeAll()
                            withAnimation (.easeInOut(duration: 0.5)) {
                                randomNumberStr = ""
                            }
                            showCopy = false
                            showDice = false
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
                                numOfDice = 1
                                numOfSides = 6
                                randomNumbers.removeAll()
                                withAnimation (.easeInOut(duration: 0.5)) {
                                    randomNumberStr = ""
                                }
                                showCopy = false
                                showDice = false
                                confirmReset = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding(.leading, 12)
        }
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode()
    }
}
