//
//  DevMode.swift
//  RNGTool Mobile
//
//  Created by Campbell on 1/8/22.
//

import SwiftUI

struct DevMode: View {
    @EnvironmentObject var settingsData: SettingsData
    @State private var historyModeInput = ""
    @State private var historyNumberInput = ""
    
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
