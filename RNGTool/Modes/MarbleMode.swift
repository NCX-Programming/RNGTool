//
//  MarbleMode.swift
//  RNGTool
//
//  Created by Campbell on 9/25/21.
//

import SwiftUI

struct MarbleMode: View {
    @AppStorage("showLetterList") private var showLetterList = false
    @State private var numOfMarbles = 1
    @State private var randomNumberStr = ""
    @State private var randomNumbers = [0]
    @State private var randomLetterStr = ""
    @State private var randomLetters: [String] = [""]
    @State private var randomLetterCopyStr = ""
    @State private var showCopy = false
    @State private var showMarbles = false
    @State private var confirmReset = false
    @State private var removeCharacters: Set<Character> = ["[", "]", "\""]
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
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
                    HStack(){
                        if(showMarbles){
                            ZStack() {
                                Text("\(letters[randomNumbers[0]])")
                                    .font(.title)
                                Circle()
                                    .stroke(Color.primary, lineWidth: 3)
                            }
                            .frame(width: 64, height: 64)
                            if(numOfMarbles>1){
                                ZStack() {
                                    Text("\(letters[randomNumbers[1]])")
                                        .font(.title)
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 3)
                                }
                                .frame(width: 64, height: 64)
                                if(numOfMarbles>2){
                                    ZStack() {
                                        Text("\(letters[randomNumbers[2]])")
                                            .font(.title)
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 3)
                                    }
                                    .frame(width: 64, height: 64)
                                    if(numOfMarbles>3){
                                        ZStack() {
                                            Text("\(letters[randomNumbers[3]])")
                                                .font(.title)
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 3)
                                        }
                                        .frame(width: 64, height: 64)
                                        if(numOfMarbles>4){
                                            ZStack() {
                                                Text("\(letters[randomNumbers[4]])")
                                                    .font(.title)
                                                Circle()
                                                    .stroke(Color.primary, lineWidth: 3)
                                            }
                                            .frame(width: 64, height: 64)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    if(showMarbles==false){
                        Spacer()
                    }
                    if (showLetterList) {
                        Text(randomLetterStr)
                            .font(.title2)
                            .padding(.bottom, 5)
                    }
                    Text(randomNumberStr)
                        .font(.title2)
                        .padding(.bottom, 5)
                    if(showCopy){
                        Button(action:{
                            randomLetterCopyStr = ""
                            randomLetterCopyStr = "\(randomLetters)"
                            randomLetterCopyStr.removeAll(where: { removeCharacters.contains($0) } )
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                            pasteboard.setString(randomLetterCopyStr, forType: NSPasteboard.PasteboardType.string)
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
                Text("Number of marbles")
                    .font(.title3)
                Picker("", selection: $numOfMarbles){
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                }
                .frame(width: 250)
                Divider()
                HStack() {
                    Button(action: {
                        showCopy = true
                        randomNumbers.removeAll()
                        randomLetters.removeAll()
                        for _ in 1..<numOfMarbles+1{
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
                        showMarbles = true
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
                        VStack(alignment: .center) {
                            Image("sheeticon")
                                .resizable()
                                .frame(width: 72, height: 72)
                            Text("Confirm Reset")
                                .font(.title2)
                            Text("Are you sure you want to reset the generator?")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 4)
                            Button(action:{
                                showMarbles = false
                                showCopy = false
                                numOfMarbles = 1
                                randomNumbers.removeAll()
                                randomLetters.removeAll()
                                withAnimation (.easeInOut(duration: 0.5)) {
                                    randomNumberStr = ""
                                }
                                withAnimation (.easeInOut(duration: 0.5)) {
                                    randomLetterStr = ""
                                }
                                confirmReset = false
                            }) {
                                Text("Confirm")
                            }
                            .controlSize(.large)
                            Button(action:{
                                confirmReset = false
                            }) {
                                Text("Cancel")
                            }
                            .controlSize(.large)
                        }
                        .frame(width: 250, height: 250)
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
