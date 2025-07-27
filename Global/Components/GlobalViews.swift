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
    // Need to check if the button is enabled so that it can be styled appropriately when disabled on macOS.
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    
    func makeBody(configuration: Configuration) -> some View {
        Group() {
            configuration.label
                .font(.system(size: 20, weight:.bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundColor(foregroundColor)
                #if os(tvOS)
                .foregroundColor(isFocused ? .black : .white)
                .background(isFocused ? Color.white.gradient : Color.accentColor.gradient)
                #elseif os(macOS)
                .apply {
                    if #available(macOS 13.0, *) {
                        if isEnabled {
                            $0.background(Color.accentColor.gradient)
                        } else {
                            $0.background(Color.gray.gradient)
                        }
                    }
                    else {
                        if isEnabled {
                            $0.background(Color.accentColor)
                            
                        } else {
                            $0.background(Color.gray)
                        }
                    }
                }
                #else
                // Apply a tasteful gradient, but unfortunately only on iOS 16.0+/macOS 13.0+/watchOS 9.0+ (sorry).
                .apply {
                    if #available(iOS 16.0, macOS 13.0, watchOS 9.0, *) {
                        $0.background(Color.accentColor.gradient)
                    }
                    else {
                        $0.background(Color.accentColor)
                    }
                }
                #endif
        }
        .cornerRadius(10)
        .opacity(opacity(configuration))
        .scaleEffect(scale(configuration))
        .shadow(color: shadowColor, radius: 20)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        #if os(tvOS)
        .focusable(true)
        #endif
    }
    
    // This creates a custom disabled effect for the buttons on macOS only.
    private func opacity(_ configuration: Configuration) -> Double {
        #if os(macOS)
        if !isEnabled {
            return 0.5
        } else if configuration.isPressed {
            return 0.7
        } else {
            return 1.0
        }
        //return isEnabled ? 1.0 : 0.5
        #elseif os(iOS)
        return configuration.isPressed ? 0.7 : 1.0
        #else
        return 1.0
        #endif
    }

    // Makes the foreground black while focused on tvOS.
    private var foregroundColor: Color {
        #if os(tvOS)
        isFocused ? .black : .white
        #else
        .white
        #endif
    }

    // Applies the correct scaling for focused and then pressed on tvOS.
    private func scale(_ configuration: Configuration) -> CGFloat {
        #if os(tvOS)
        return (configuration.isPressed ? 0.9 : 1.0) * (isFocused ? 1.05 : 1.0)
        #else
        return 1.0
        #endif
    }

    // Adds a shadow while the button is focused on tvOS.
    private var shadowColor: Color {
        #if os(tvOS)
        return .black.opacity(isFocused ? 0.8 : 0)
        #else
        return .clear
        #endif
    }
}

// Custom view that allows me to show monospace symbols in places like the generate/reset buttons. For some reason there isn't a way to
// do this directly, so this view uses the full-size circle symbol and then overlays the intended symbol over it.
struct MonospaceSymbol: View {
    let symbol: String
    
    var body: some View {
        Image(systemName: "circle")
            .opacity(0)
            .overlay {
                Image(systemName: symbol)
            }
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

// Helper function to build a map of the item grids because the old method of having all the math in my UI code was overwhelming
// the compiler and preventing type-checking from succeeding. Used for both dice and marbles on macOS and iOS.
func getItemGrid(numItems: Int, numCols: Int) -> [[Int]] { // Side-note: I like Swift's Python-esque return type annotations. I feel right at home.
    let numRows = Int((Double(numItems) / Double(numCols)).rounded(.up))
    // And then this kinda feels like Rust's mapping. Am I doing this correctly? I hope so.
    return (0..<numRows).map { row in
        let startIdx = (numCols * row)
        // This math HAS to be improvable somehow. I just kinda forgot what's happening in it.
        let endIdx = (numItems > (numCols * (row + 1)) ? numItems - (numItems - (numCols * (row + 1))) : numItems)
        return Array(startIdx..<endIdx)
    }
}
