//
//  SettingsView.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/22/21.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
            case number, dice, card
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
