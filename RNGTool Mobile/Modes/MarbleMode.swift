//
//  MarbleMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/19/21.
//

import SwiftUI

struct MarbleMode: View {
    @AppStorage("confirmGenResets") private var confirmGenResets = true
    @AppStorage("showLetterList") private var showLetterList = false
    @State private var numOfMarbles = 1
    @State private var randomNumberStr = ""
    @State private var randomNumbers = [0]
    @State private var randomLetterStr = ""
    @State private var randomLetters = [String]()
    @State private var randomLetterCopyStr = ""
    @State private var showMarbles = false
    @State private var confirmReset = false
    @State private var removeCharacters: Set<Character> = ["[", "]", "\""]
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func resetGen() {
        withAnimation (.easeInOut(duration: 0.5)) {
            randomNumberStr = ""
            randomLetterStr = ""
            showMarbles = false
        }
        numOfMarbles = 1
        randomNumbers.removeAll()
        randomLetters.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        ScrollView {
            Group {
                Text("Generate multiple letters using marbles")
                    .font(.title3)
                Divider()
                if(showMarbles){
                    HStack(){
                        ForEach(0..<numOfMarbles, id: \.self) { index in
                            ZStack() {
                                Text("\(letters[randomNumbers[index]])")
                                    .font(.title)
                                Circle()
                                    .stroke(Color.primary, lineWidth: 3)
                            }
                            .frame(width: (UIScreen.main.bounds.size.width / 5) - 10, height: (UIScreen.main.bounds.size.width / 5) - 10)
                        }
                    }
                }
                if(showLetterList) {
                    Text(randomLetterStr)
                        .padding(.bottom, 5)
                }
                Text(randomNumberStr)
                    .padding(.bottom, 5)
                if(showMarbles){
                    Button(action:{
                        randomLetterCopyStr = ""
                        randomLetterCopyStr = "\(randomLetters)"
                        randomLetterCopyStr.removeAll(where: { removeCharacters.contains($0) } )
                        copyToClipboard(item: "\(randomLetterCopyStr)")
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
            Text("Number of marbles")
                .font(.title3)
            Picker("", selection: $numOfMarbles){
                ForEach(1..<6, id: \.self) { index in
                    Text("\(index)").tag(index)
                }
            }
            .pickerStyle(.segmented)
            Divider()
            HStack() {
                Button(action: {
                    randomNumbers.removeAll()
                    randomLetters.removeAll()
                    for _ in 1..<6{
                        randomNumbers.append(Int.random(in: 0..<26))
                    }
                    withAnimation (.easeInOut(duration: 0.5)) {
                        randomNumberStr = "Your random number(s): \(randomNumbers)"
                        randomNumberStr.removeAll(where: { removeCharacters.contains($0) } )
                    }
                    for i in 0..<numOfMarbles {
                        randomLetters.append(letters[randomNumbers[i]])
                    }
                    withAnimation (.easeInOut(duration: 0.5)) {
                        randomLetterStr = "Your random letter(s): \(randomLetters)"
                        randomLetterStr.removeAll(where: { removeCharacters.contains($0) } )
                    }
                    withAnimation(.easeInOut(duration: 0.5)){
                        showMarbles = true
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
        .navigationTitle("Marbles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode()
    }
}
