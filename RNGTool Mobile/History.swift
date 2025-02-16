//
//  History.swift
//  RNGTool Mobile
//
//  Created by Campbell on 1/7/22.
//

import SwiftUI

struct History: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    Text("Mode Used")
                        .foregroundColor(.secondary)
                    Divider()
                    ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                        Text("\(settingsData.historyTable[index].modeUsed)")
                            .padding(.bottom, 3)
                    }
                    Spacer()
                }
                VStack {
                    Text("Result(s)")
                        .foregroundColor(.secondary)
                    Divider()
                    ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                        Text("\(settingsData.historyTable[index].numbers)")
                            .padding(.bottom, 3)
                            .textSelection(.enabled)
                    }
                    Spacer()
                }
            }
            if(settingsData.historyTable.count == 0) {
                Text("No history yet! Get generating!")
            }
        }
        .padding(.horizontal, 3)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History().environmentObject(SettingsData())
    }
}
