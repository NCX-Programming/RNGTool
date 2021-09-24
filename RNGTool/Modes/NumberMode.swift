//
//  NumberMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct NumberMode: View {
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    @State private var confirmReset = false
    @State private var showCopy = false
    @State private var randomNumber = 0
    @State private var randomNumberStr = ""
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var maxNumber = 0
    @State private var minNumber = 0
    var body: some View {
        VStack(alignment: .leading){
            Text("Number Mode")
                .font(.title)
            Text("Generate a single number using a maximum and minimum number")
                .font(.title3)
                .foregroundColor(.secondary)
            Divider()
            Text(randomNumberStr)
                .font(.title2)
                .padding(.bottom, 5)
            if(randomNumber != 0){
                Button(action:{
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                    pasteboard.setString("\(randomNumber)", forType: NSPasteboard.PasteboardType.string)
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
            Text("Maximum Number (Default: \(maxNumberDefault))")
                .font(.subheadline)
                .padding(.top, 10)
            TextField("Enter a number", text: $maxNumberInput)
                .frame(width: 300)
            Text("Minimum Number (Default: \(minNumberDefault), must be less than maximum number)")
                .font(.subheadline)
                .padding(.top, 10)
            TextField("Enter a number", text: $minNumberInput)
                .frame(width: 300)
            HStack {
                Button(action:{
                    maxNumber = Int(maxNumberInput) ?? maxNumberDefault
                    minNumber = Int(minNumberInput) ?? minNumberDefault
                    randomNumber = Int.random(in: minNumber..<maxNumber)
                    withAnimation (.easeInOut(duration: 0.5)) {
                        self.randomNumberStr = "Your random number: \(randomNumber)"
                    }
                }) {
                    Image(systemName: "play.fill")
                        
                }
                .padding(.vertical, 10)
                .help("Generate a number")
                Button(action:{
                    maxNumber = 0
                    maxNumberInput = ""
                    minNumber = 0
                    minNumberInput = ""
                }) {
                    Image(systemName: "goforward")
                }
                .help("Clear custom values")
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
                            maxNumber = 0
                            maxNumberInput = ""
                            minNumber = 0
                            minNumberInput = ""
                            randomNumber = 0
                            withAnimation (.easeInOut(duration: 0.5)) {
                                randomNumberStr = ""
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

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode()
    }
}
