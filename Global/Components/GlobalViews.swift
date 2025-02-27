//
//  Views.swift
//  RNGTool
//
//  Created by Campbell on 2/25/25.
//
//  Contains any global custom view extensions, modifiers, or styles, as well as any functions related to visual content.
//

import SwiftUI

// This is the large button style originally used in the number mode redesign
struct LargeSquareAccentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.white)
            // Apply a tasteful gradient, but unfortunately only on iOS 16.0+ (sorry).
            .apply {
                if #available(iOS 16.0, macOS 13.0, watchOS 9.0, *) {
                    $0.background(Color.accentColor.gradient)
                }
                else {
                    $0.background(Color.accentColor)
                }
            }
            .cornerRadius(10)
    }
}

// Custom modifier designed for Text() that makes it as large as possible given the screen space, while allowing it to dynamically scale
// down as small as required. Originally made for the redesigned number mode.
struct MaxSizeText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 1000))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
            .allowsTightening(true)
    }
}
extension View {
    func maxSizeText() -> some View {
        modifier(MaxSizeText())
    }
}

// Custom view extension that just applies modifiers in a block to the object it's applied to. Mostly useful for splitting up conditional
// modifiers that should only be applied for certain OS versions.
extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
