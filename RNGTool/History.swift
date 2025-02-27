//
//  History.swift
//  RNGTool
//
//  Created by Campbell on 12/25/21.
//

import SwiftUI
import Foundation

struct History: View {
    @EnvironmentObject var settingsData: SettingsData
    @State private var selectedEntries = Set<HistoryTable.ID>()
    
    var body: some View {
        // History on macOS, now with 100% more actual table! This looks much much better.
        Table(settingsData.historyTable, selection: $selectedEntries) {
            TableColumn("Mode Used") { item in
                Text(item.modeUsed)
                    .contextMenu {
                        Button("Copy") {
                            copyToClipboard(item: item.modeUsed)
                        }
                    }
            }
            TableColumn("Result(s)") { item in
                Text(item.numbers)
                    .contextMenu {
                        Button("Copy") {
                            copyToClipboard(item: item.numbers)
                        }
                    }
            }
        }
    }
}

#Preview {
    History().environmentObject(SettingsData())
}
