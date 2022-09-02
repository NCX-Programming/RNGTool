//
//  SettingsView.swift
//  RNGTool
//
//  Created by Campbell on 9/22/21.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
            case number, dice, card, marble, interface, advanced
    }
    var body: some View {
        TabView {
            NumberSettings()
                .tabItem {
                    Label("Number Mode", systemImage: "number")
                }
                .tag(Tabs.number)
            Form {
                DiceSettings()
            }
            .tabItem {
                Label("Dice Mode", image: "dice")
            }
            .tag(Tabs.dice)
            Form {
                CardSettings()
            }
            .tabItem {
                Label("Card Mode", systemImage: "rectangle.grid.3x2")
            }
            .tag(Tabs.card)
            Form {
                MarbleSettings()
            }
            .tabItem {
                Label("Marble Mode", systemImage: "a.circle")
            }
            .tag(Tabs.marble)
            Form {
                InterfaceSettings()
            }
            .tabItem {
                Label("Interface Settings", systemImage: "display")
            }
            .tag(Tabs.interface)
            Form {
                AdvancedSettings()
            }
            .tabItem {
                Label("Advanced Settings", systemImage: "gear")
            }
            .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 500, height: 350)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
