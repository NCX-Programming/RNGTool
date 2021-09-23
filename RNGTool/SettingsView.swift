//
//  SettingsView.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/22/21.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
            case general, advanced
    }
    var body: some View {
        TabView {
            DiceSettings()
                .tabItem {
                    Label("Dice Mode", image: "dice")
                }
                .tag(Tabs.general)
            CardSettings()
                .tabItem {
                    Label("Card Mode", systemImage: "rectangle.grid.3x2")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
