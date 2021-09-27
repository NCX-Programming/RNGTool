//
//  MarbleSettings.swift
//  RNGTool
//
//  Created by Campbell Bagley on 9/27/21.
//

import SwiftUI

struct MarbleSettings: View {
    @AppStorage("showLetterList") private var showLetterList = false
    
    var body: some View {
        Form {
            Toggle("Show list of letters below marble icons", isOn: $showLetterList)
            Text("This will make it so that a list of letters will be shown below the marble icons. This is mostly for accessibility.")
                .foregroundColor(.secondary)
        }
        .padding(20)
        .frame(width: 350, height: 300)
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings()
    }
}
