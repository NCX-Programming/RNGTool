//
//  MarbleMode.swift
//  RNGTool
//
//  Created by Campbell on 9/25/21.
//

import SwiftUI

struct MarbleMode: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Marble Mode")
                        .font(.title)
                    Text("Generate multiple numbers or letters using dice")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Divider()
                }
            }
            .padding(.leading, 12)
        }
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode()
    }
}
