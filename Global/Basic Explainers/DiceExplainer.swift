//
//  DiceExplainer.swift
//  RNGTool
//
//  Created by Campbell on 7/14/25.
//

import SwiftUI

struct DiceExplainer: View {
    func getExplainerText() -> String {
        var text = "Roll some dice! Select the number of dice you want to roll, and then press play to see what you get."
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
    DiceExplainer()
}
