//
//  About.swift
//  RNGTool Mobile
//
//  Created by Campbell on 12/20/21.
//

import SwiftUI

struct About: View {
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    var body: some View {
        ScrollView {
            Text("RNGTool")
                .font(.title)
            Text("Version: v\(appVersionString), Build: \(buildNumber)")
                .foregroundColor(.secondary)
                .font(.title2)
            Text("© 2021 NCX Programming")
                .foregroundColor(.secondary)
                .font(.title3)
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
