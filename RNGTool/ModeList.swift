//
//  ModeList.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct ModeList: View {
    var body: some View {
        NavigationView {
            List() {
                Text("Modes")
                    .font(.title)
                Divider()
                NavigationLink(destination: NumberMode()) {
                    HStack {
                        VStack() {
                            Text("Numbers")
                                .padding(.leading, 5)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                NavigationLink(destination: DiceMode()) {
                    HStack {
                        VStack() {
                            Text("Dice")
                                .bold()
                                .padding(.leading, 5)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                NavigationLink(destination: CardMode()) {
                    HStack {
                        VStack() {
                            Text("Cards")
                                .bold()
                                .padding(.leading, 5)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                NavigationLink(destination: MarbleMode()) {
                    HStack {
                        VStack() {
                            Text("Marbles")
                                .bold()
                                .padding(.leading, 5)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("RNGTool")
            .frame(minWidth: 200)
            .toolbar{
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: { // 1
                        Image(systemName: "sidebar.leading")
                    })
                }
            }
            Text("Select a mode to start generating")
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ModeList_Previews: PreviewProvider {
    static var previews: some View {
        ModeList()
    }
}
