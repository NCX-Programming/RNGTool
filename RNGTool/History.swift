//
//  History.swift
//  RNGTool
//
//  Created by Campbell Bagley on 12/25/21.
//

import SwiftUI

struct History: View {
    @StateObject var settingsData: SettingsData = SettingsData()
    
    var body: some View {
        Text("Hello World!")
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
