//
//  NumberMode.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }
}

struct NumberMode: View {
    @AppStorage("confirmGenResets") private var confirmGenResets = true
    @AppStorage("maxNumberDefault") private var maxNumberDefault = 100
    @AppStorage("minNumberDefault") private var minNumberDefault = 0
    @State private var confirmReset = false
    @State private var showCopy = false
    @State private var showMaxEditor = false
    @State private var showMinEditor = false
    @State private var randomNumber = 0
    @State private var randomNumberStr = ""
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var maxNumber = 0
    @State private var minNumber = 0
    var body: some View {
        ScrollView {
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
                Group() {
                    Text("Default Maximum Number: \(maxNumberDefault). Right click to set a custom value.")
                        .contextMenu {
                            Toggle("Show Editor", isOn: $showMaxEditor)
                            Button(action: {
                                maxNumber = 0
                                maxNumberInput = ""
                                showMaxEditor.toggle()
                            }) {
                                Text("Set to Default")
                            }
                        }
                        .help("Right click here to set a custom maximum number")
                    if(showMaxEditor){
                        TextField("Enter a number", text: $maxNumberInput)
                            .frame(width: 300)
                    }
                    Divider()
                    Text("Default Minimum Number: \(minNumberDefault). Right click to set a custom value.")
                        .contextMenu {
                            Toggle("Show Editor", isOn: $showMinEditor)
                            Button(action: {
                                minNumber = 0
                                minNumberInput = ""
                                showMinEditor.toggle()
                            }) {
                                Text("Set to Default")
                            }
                        }
                        .help("Right click here to set a custom minimum number")
                    if(showMinEditor){
                        TextField("Enter a number", text: $minNumberInput)
                            .frame(width: 300)
                    }
                    Divider()
                }
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
                    .help("Generate a number")
                    Button(action:{
                        if(confirmGenResets){
                            confirmReset = true
                        }
                        else {
                            maxNumber = 0
                            maxNumberInput = ""
                            minNumber = 0
                            minNumberInput = ""
                            randomNumber = 0
                            showMaxEditor = false
                            showMinEditor = false
                            withAnimation (.easeInOut(duration: 0.5)) {
                                randomNumberStr = ""
                            }
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
                                maxNumber = 0
                                maxNumberInput = ""
                                minNumber = 0
                                minNumberInput = ""
                                randomNumber = 0
                                showMaxEditor = false
                                showMinEditor = false
                                withAnimation (.easeInOut(duration: 0.5)) {
                                    randomNumberStr = ""
                                }
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

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode()
    }
}
