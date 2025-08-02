//
//  CardExplainer.swift
//  RNGTool
//
//  Created by Campbell on 7/14/25.
//

import SwiftUI

struct CardExplainer: View {
    var body: some View {
        Text("Draw some cards! Simulates a full deck of 52 cards each hand, so you'll only ever gets hands that are possible to draw from a real deck of cards. Spontaneous game of \"go fish\", anyone? ...anyone?\n\nThe point values commonly assigned to each card can be displayed by enabling \"Show card point values\" in settings.")
    }
}

#Preview {
    CardExplainer()
}
