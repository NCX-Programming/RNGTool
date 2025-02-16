//
//  Components.swift
//  RNGTool Mobile
//
//  Created by Campbell on 2/15/25.
//

import SwiftUI

struct LargeSquareAccentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}
