//
//  MarbleMode.swift
//  RNGTool
//
//  Created by Campbell on 9/25/21.
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
            VStack(alignment: .leading) {
                Group {
                    Text("Marble Mode")
                        .font(.title)
                    Text("Generate multiple letters using marbles")
                        .font(.title3)
                        .foregroundColor(.secondary)
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
                                .frame(width: 64, height: 64)
                            }
                        }
                    }
                    if(showLetterList) {
                        Text(randomLetterStr)
                            .font(.title2)
                            .padding(.bottom, 5)
                    }
                    Text(randomNumberStr)
                        .font(.title2)
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
                .frame(width: 250)
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
            }
            .padding(.leading, 12)
        }
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode()
    }
}
