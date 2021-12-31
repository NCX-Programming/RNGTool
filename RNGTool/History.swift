//
//  History.swift
//  RNGTool
//
//  Created by Campbell on 12/25/21.
//

import SwiftUI
import Foundation

struct ExampleRow: View {
    var body: some View {
        Text("Example Row")
    }
}

struct History: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        ScrollView {
            HStack {
                List {
                    Section(header: Text("ID")) {
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(index)")
                        }
                    }
                }
                .disabled(true)
                .frame(width: 50, height: 200)
                List {
                    Section(header: Text("Mode Used")) {
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(settingsData.historyTable[index].modeUsed)")
                        }
                    }
                }
                .disabled(true)
                .frame(width: 150, height: 200)
                List {
                    Section(header: Text("Number(s)")) {
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(settingsData.historyTable[index].numbers)")
                        }
                    }
                }
                .disabled(true)
                .frame(width: 200, height: 200)
            }
        }
        .frame(width: 400, height: 200)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
