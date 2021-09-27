//
//  SettingsView.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
            case number, dice, card, marble
    }
    var body: some View {
        TabView {
            NumberSettings()
                .tabItem {
                    Label("Number Mode", systemImage: "number")
                }
                .tag(Tabs.number)
            DiceSettings()
                .tabItem {
                    Label("Dice Mode", image: "dice")
                }
                .tag(Tabs.dice)
            CardSettings()
                .tabItem {
                    Label("Card Mode", systemImage: "rectangle.grid.3x2")
                }
                .tag(Tabs.card)
            MarbleSettings()
                .tabItem {
                    Label("Marble Mode", systemImage: "a.circle")
                }
                .tag(Tabs.marble)
        }
        .padding(20)
        .frame(width: 375, height: 350)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
