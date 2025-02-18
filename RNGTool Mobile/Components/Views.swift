//
//  Views.swift
//  RNGTool Mobile
//
//  Created by Campbell on 2/15/25.
//
//  Contains any custom view extensions, modifiers, or styles, as well as any functions related to visual content.
//

import SwiftUI
import UIKit
import Foundation

// This is the large button style originally used in the number mode redesign
struct LargeSquareAccentButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight:.bold, design: .rounded))
            .foregroundColor(.white)
            .background(Color.accentColor)
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

// Function that finds a good size for the dice in dice mode based off of the screen size. Also used in marble mode for the same purpose.
func getDieSize(geometry: GeometryProxy) -> CGFloat {
    // Currently using some different (and somewhat rough) calculations for iPad, because the die size calculations used for iPhone
    // don't work for the bigger screen, especially when you take the sidebar into account.
    let smallerLength = min(geometry.size.width, geometry.size.height)
    var dieSize: CGFloat
    if UIDevice.current.userInterfaceIdiom == .pad {
        dieSize = (smallerLength / 4.25) - 15
    }
    else {
        dieSize = (smallerLength / 3) - 15
    }
    return dieSize
}
