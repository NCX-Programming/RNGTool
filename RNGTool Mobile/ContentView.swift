//
//  ContentView.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsData: SettingsData
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("RNGTool")) {
                    NavigationLink(destination: NumberMode()) {
                        Image(systemName: "number")
                            .foregroundColor(.accentColor)
                        Text("Numbers")
                    }
                    NavigationLink(destination: DiceMode()) {
                        Image(systemName: "dice")
                            .foregroundColor(.accentColor)
                        Text("Dice")
                    }
                    NavigationLink(destination: CardMode()) {
                        Image(systemName: "rectangle.grid.3x2")
                            .foregroundColor(.accentColor)
                        Text("Cards")
                    }
                    NavigationLink(destination: MarbleMode()) {
                        Image(systemName: "a.circle")
                            .foregroundColor(.accentColor)
                        Text("Marbles")
                    }
                }
                
                Section(header: Text("More")) {
                    #if os(watchOS)
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.accentColor)
                        Text("Settings")
                    }
                    #endif
                    #if os(iOS)
                    NavigationLink(destination: History()) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.accentColor)
                        Text("History")
                    }
                    if(settingsData.showDevMode) {
                        NavigationLink(destination: DevMode()) {
                            Image(systemName: "hammer")
                                .foregroundColor(.accentColor)
                            Text("Developer Mode")
                        }
                    }
                    #endif
                }
            }
            .navigationTitle("RNGTool")
            #if !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            #endif
            Text("Select a mode to start generating")
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(SettingsData())
        }
    }
}
