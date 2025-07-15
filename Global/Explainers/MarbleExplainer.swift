//
//  MarbleExplainer.swift
//  RNGTool
//
//  Created by Campbell on 7/14/25.
//

import SwiftUI

struct MarbleExplainer: View {
    func getExplainerText() -> String {
        var text = "Roll some marbles! Why marbles, you ask? I don't really know. This was just the first thing I thought of when trying to give some sort of visual element to choosing random letters."
        #if os(iOS)
        text += "\n\nYou can also try shaking your device to roll! (This can be disabled in settings, if you'd prefer.)"
        #endif
        return text
    }
    
    var body: some View {
        Text(getExplainerText())
    }
}

#Preview {
    MarbleExplainer()
}
