//
//  CoinExplainer.swift
//  RNGTool
//
//  Created by Campbell on 7/14/25.
//

import SwiftUI

struct CoinExplainer: View {
    var body: some View {
        Text("Flip some coins! Select the number of coins to flip, and then press play to see how many heads and tails you get. If the statistics portion of my high school algebra class was telling the truth, the two numbers should stay relatively similar to one another.")
        #if os(iOS)
        Text("On iPhone, features haptic feedback for each coin flipped!")
        #endif
    }
}

#Preview {
    CoinExplainer()
}
