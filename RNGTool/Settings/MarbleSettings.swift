//
//  MarbleSettings.swift
//  RNGTool
//
//  Created by Campbell on 9/27/21.
//

import SwiftUI

struct MarbleSettings: View {
    @AppStorage("showLetterList") private var showLetterList = false
    
    var body: some View {
        Toggle("Show list of letters", isOn: $showLetterList)
        Text("This will make it so that a list of letters will be shown below the marble icons.")
            .foregroundColor(.secondary)
    }
}

struct MarbleSettings_Previews: PreviewProvider {
    static var previews: some View {
        MarbleSettings()
    }
}
