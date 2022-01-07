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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("ID")
                            .foregroundColor(.secondary)
                        Divider()
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(index)")
                                .padding(.bottom, 3)
                        }
                        Spacer()
                    }
                    .frame(width: 50)
                    VStack(alignment: .leading) {
                        Text("Mode Used")
                            .foregroundColor(.secondary)
                        Divider()
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(settingsData.historyTable[index].modeUsed)")
                                .padding(.bottom, 3)
                        }
                        Spacer()
                    }
                    .frame(width: 150)
                    VStack(alignment: .leading) {
                        Text("Number(s)")
                            .foregroundColor(.secondary)
                        Divider()
                        ForEach(0..<settingsData.historyTable.count, id: \.self) { index in
                            Text("\(settingsData.historyTable[index].numbers)")
                                .padding(.bottom, 3)
                        }
                        Spacer()
                    }
                    .frame(width: 200)
                }
                .padding(.top, 6)
                .padding(.leading, 8)
            }
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History().environmentObject(SettingsData())
    }
}
