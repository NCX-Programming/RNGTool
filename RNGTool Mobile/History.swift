//
//  History.swift
//  RNGTool Mobile
//
//  Created by Campbell on 1/7/22.
//

import SwiftUI

struct History: View {
    @EnvironmentObject var settingsData: SettingsData
    @State private var confirmReset: Bool = false
    
    func clearHistory() {
        settingsData.historyTable.removeAll()
        confirmReset = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    VStack {
                        Text("Mode Used")
                            .foregroundColor(.secondary)
                        Divider()
                    }
                    VStack {
                        Text("Result(s)")
                            .foregroundColor(.secondary)
                        Divider()
                    }
                }
                if(settingsData.historyTable.count == 0) {
                    Text("No history yet! Get generating!")
                }
                // Actual entries are shown here
                ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                    HStack(alignment: .center) {
                        VStack {
                            Text("\(settingsData.historyTable[index].modeUsed)")
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: (geometry.size.width * 0.5) - 6)
                        VStack {
                            Text("\(settingsData.historyTable[index].numbers)")
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: (geometry.size.width * 0.5) - 6)
                    }
                    .padding(.bottom, 3)
                }
            }
        }
        .padding(.horizontal, 3)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    confirmReset = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .alert("Clear History", isPresented: $confirmReset, actions: {
            Button("Confirm", role: .destructive) {
                clearHistory()
            }
        }, message: {
            Text("Are you sure you want to clear your RNGTool history?")
        })
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History().environmentObject(SettingsData())
    }
}
