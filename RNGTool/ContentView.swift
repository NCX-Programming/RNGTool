//
//  ContentView.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ModeList()
            .frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
