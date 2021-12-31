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
    @EnvironmentObject var settingsData: SettingsData
    @State private var confirmReset = false
    @State private var showMaxEditor = false
    @State private var showMinEditor = false
    @State private var showCopy = false
    @State private var randomNumber = 0
    @State private var randomNumberStr = ""
    @State private var maxNumberInput = ""
    @State private var minNumberInput = ""
    @State private var maxNumber = 0
    @State private var minNumber = 0
    
    func resetGen() {
        maxNumber = 0
        maxNumberInput = "\(settingsData.maxNumberDefault)"
        minNumber = 0
        minNumberInput = "\(settingsData.minNumberDefault)"
        randomNumber = 0
        withAnimation (.easeInOut(duration: 0.5)) {
            randomNumberStr = ""
            showMaxEditor = false
            showMinEditor = false
            showCopy = false
        }
        confirmReset = false
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                Text("Generate a single number using a maximum and minimum number")
                    .font(.title3)
                Divider()
                Text(randomNumberStr)
                    .font(.title2)
                    .padding(.bottom, 5)
                if(showCopy){
                    Button(action:{
                        copyToClipboard(item: "\(randomNumber)")
                    }) {
                        Image(systemName: "doc.on.doc.fill")
                    }
                    .padding(.bottom, 10)
                    Divider()
                }
                Group() {
                    Text("Maximum Number: \(maxNumberInput). Right click to set a custom value.")
                        .contextMenu {
                            Toggle("Show Editor", isOn: $showMaxEditor)
                            Button(action: {
                                maxNumber = 0
                                maxNumberInput = ""
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMaxEditor.toggle()
                                }
                            }) {
                                Text("Set to Default")
                            }
                        }
                        .help("Right click here to set a custom maximum number")
                        .onAppear{
                            maxNumberInput="\(settingsData.maxNumberDefault)"
                        }
                    if(showMaxEditor){
                        TextField("Enter a number", text: $maxNumberInput)
                            .frame(width: 300)
                            
                    }
                    Divider()
                    Text("Minimum Number: \(settingsData.minNumberDefault). Right click to set a custom value.")
                        .contextMenu {
                            Toggle("Show Editor", isOn: $showMinEditor)
                            Button(action: {
                                minNumber = 0
                                minNumberInput = ""
                                withAnimation (.easeInOut(duration: 0.5)){
                                    showMinEditor.toggle()}
                            }) {
                                Text("Set to Default")
                            }
                        }
                        .help("Right click here to set a custom minimum number")
                        .onAppear{
                            minNumberInput="\(settingsData.minNumberDefault)"
                        }
                    if(showMinEditor){
                        TextField("Enter a number", text: $minNumberInput)
                            .frame(width: 300)
                    }
                    Divider()
                }
                HStack {
                    Button(action:{
                        maxNumber = Int(maxNumberInput) ?? settingsData.maxNumberDefault
                        minNumber = Int(minNumberInput) ?? settingsData.minNumberDefault
                        randomNumber = Int.random(in: minNumber..<maxNumber)
                        withAnimation (.easeInOut(duration: 0.5)) {
                            showCopy = true
                            self.randomNumberStr = "Your random number: \(randomNumber)"
                        }
                        maxNumberInput="\(maxNumber)"
                        minNumberInput="\(minNumber)"
                        
                        self.settingsData.historyTable.append(HistoryTable(modeUsed: "Number Mode", numbers: "\(randomNumber)"))
                    }) {
                        Image(systemName: "play.fill")
                            
                    }
                    .help("Generate a number")
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
        .navigationTitle("Numbers")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct NumberMode_Previews: PreviewProvider {
    static var previews: some View {
        NumberMode()
    }
}
