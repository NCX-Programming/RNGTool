//
//  DiceMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
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
    @State private var showDice = false
    @State private var removeCharacters: Set<Character> = ["[", "]"]
    @State private var diceImages = [String]()
    
    func resetGen() {
        withAnimation(.easeInOut(duration: 0.5)){
            randomNumberStr = ""
            showDice = false
        }
        numOfDice = 1
        numOfSides = 6
        randomNumbers.removeAll()
        confirmReset = false
    }
    
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
            Group {
                Text("Generate multiple numbers using dice")
                    .font(.title3)
                Divider()
                if(showDice && allowDiceImages){
                    HStack(){
                        ForEach(0..<numOfDice, id: \.self) { index in
                          Image(diceImages[index])
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.size.width / 6) - 10, height: (UIScreen.main.bounds.size.width / 6) - 10)
                        }
                    }
                }
                Text(randomNumberStr)
                    .padding(.bottom, 5)
                if(showDice){
                    Button(action:{
                        copyToClipboard(item: "\(randomNumbers)")
                    }) {
                        Image(systemName: "doc.on.doc.fill")
                    }
                    .font(.system(size: 12, weight:.bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(5)
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .padding(.bottom, 10)
                    Divider()
                }
            }
            Text("Number of dice")
                .font(.title3)
            // The seemingly unrelated code below is together because they must have the same max value
            Picker("Number of dice", selection: $numOfDice){
                ForEach(1..<7, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            .pickerStyle(.segmented)
            .onAppear{
                for _ in 1..<7{
                    diceImages.append("d1")
                }
            }
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
                    randomNumbers.removeAll()
                    for _ in 1..<numOfDice+1{
                        randomNumbers.append(Int.random(in: 1..<numOfSides+1))
                    }
                    withAnimation (.easeInOut(duration: 0.5)) {
                        self.randomNumberStr = "Your random number(s): \(randomNumbers)"
                        randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                    }
                    if(numOfSides==6){
                        withAnimation(.easeInOut(duration: 0.5)){
                            showDice = true
                        }
                        for n in 0..<randomNumbers.count{
                            if(numOfDice>n) {diceImages[n]="d\(randomNumbers[n])"}
                        }
                    }
                    else{
                        withAnimation(.easeInOut(duration: 0.5)){
                            showDice = false
                        }
                    }
                }) {
                    Image(systemName: "play.fill")
                }
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(20)
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
            }
        }
        .padding(.horizontal, 3)
        .navigationTitle("Dice")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiceMode_Previews: PreviewProvider {
    static var previews: some View {
        DiceMode()
    }
}
