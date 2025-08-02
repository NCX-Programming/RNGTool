//
//  DealerExplainer.swift
//  RNGTool
//
//  Created by Campbell on 8/1/25.
//

import SwiftUI

struct DealerExplainer: View {
    var body: some View {
        Text("Deal out several hands of cards at once! Cards dealt to each hand are pulled from the same deck, allowing for realistic card distribution.\n\nYou can also deal an additional card to each hand using the plus button at the bottom, or deal an additional card to just one hand by pressing the plus button on that hand.")
    }
}

#Preview {
    DealerExplainer()
}
