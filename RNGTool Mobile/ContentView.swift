//
//  ContentView.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/14/21.
//

import SwiftUI
import UIKit

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationViewStyle(.automatic)
        } else {
            self.navigationViewStyle(.stack)
        }
    }
}

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
                }
            }
            .navigationTitle("RNGTool")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            Text("Select a mode to start generating")
        }
        .phoneOnlyStackNavigationView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(SettingsData())
        }
    }
}
