//
//  DevMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 1/8/22.
//

import SwiftUI

struct DevMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @SceneStorage("NumberMode.randomNumber") private var randomNumber = 0
    @SceneStorage("NumberMode.maxNumber") private var maxNumber = 0
    @SceneStorage("NumberMode.minNumber") private var minNumber = 0
    @State private var historyModeInput = ""
    @State private var historyNumberInput = ""
    @State private var randomNumberStr = ""
    @State private var maxNumberStr = ""
    @State private var minNumberStr = ""
    
    var body: some View {
        Form {
            Section(header: Text("History Table Manipulation"), footer: Text("This will append a new entry with the specified values to the number history table. This does not check for a maximum before appending.")) {
                Text("Mode Used")
                TextField(text: $historyModeInput, prompt: Text("Required")) {
                    Text("Mode Used")
                }
                Text("Numbers")
                TextField(text: $historyNumberInput, prompt: Text("Required")) {
                    Text("Numbers")
                }
                Button(action:{
                    addHistoryEntry(settingsData: settingsData, results: historyNumberInput, mode: historyModeInput)
                }) {
                    Text("Append")
                }
            }
            Section(footer: Text("This will erase all entries in the table.")) {
                Text("Entries: \(settingsData.historyTable.count)")
                Button(action:{
                    settingsData.historyTable.removeAll()
                }) {
                    Text("Reset Table")
                }
            }
            Section(header: Text("@SceneStorage Manipulation"), footer: Text("Edit the values stored in @SceneStorage for Number Mode.")) {
                Text("randomNumber: \(randomNumber)")
                TextField(text: $randomNumberStr, prompt: Text("Enter a number")) {
                    Text("Numbers")
                }
                .onChange(of: randomNumberStr) { randomNumberStr in
                    randomNumber = Int(randomNumberStr.prefix(19)) ?? 0
                }
                .onAppear {
                    randomNumberStr = "\(randomNumber)"
                }
                .keyboardType(.numberPad)
                Text("maxNumber: \(maxNumber)")
                TextField(text: $maxNumberStr, prompt: Text("Enter a number")) {
                    Text("Numbers")
                }
                .onChange(of: maxNumberStr) { maxNumberStr in
                    maxNumber = Int(maxNumberStr.prefix(19)) ?? settingsData.maxNumberDefault
                }
                .onAppear {
                    maxNumberStr = "\(maxNumber)"
                }
                .keyboardType(.numberPad)
                Text("minNumber: \(minNumber)")
                TextField(text: $minNumberStr, prompt: Text("Enter a number")) {
                    Text("Numbers")
                }
                .onChange(of: minNumberStr) { minNumberStr in
                    minNumber = Int(minNumberStr.prefix(19)) ?? settingsData.minNumberDefault
                }
                .onAppear {
                    minNumberStr = "\(minNumber)"
                }
                .keyboardType(.numberPad)
            }
        }
        .padding(.horizontal, 3)
        .navigationTitle("Developer Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DevMode_Previews: PreviewProvider {
    static var previews: some View {
        DevMode().environmentObject(SettingsData())
    }
}
