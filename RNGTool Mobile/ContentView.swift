//
//  ContentView.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/14/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Modes")) {
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
                }
            }
            .navigationTitle("RNGTool")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            Text("Select a mode to start generating")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
