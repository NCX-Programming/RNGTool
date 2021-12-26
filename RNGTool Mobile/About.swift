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
    let copyright: String = Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as! String
    
    var body: some View {
        ScrollView {
            Text("RNGTool")
                .font(.title)
            Text("Version: v\(appVersionString), Build: \(buildNumber)")
                .foregroundColor(.secondary)
                .font(.title2)
            Text(copyright)
                .foregroundColor(.secondary)
                .font(.title3)
            Spacer()
            Text("Powered by Swift and SwiftUI")
                .padding(.bottom, 25)
            Link(destination: URL(string:"https://github.com/NCX-Programming")!) {
                Image(systemName: "link.circle")
                Text("Our GitHub")
            }
                .frame(maxWidth: UIScreen.main.bounds.width-50)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
            Link(destination: URL(string:"https://github.com/NCX-Programming/RNGTool")!) {
                Image(systemName: "link.circle")
                Text("This Project")
            }
                .frame(maxWidth: UIScreen.main.bounds.width-50)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
            Link(destination: URL(string:"https://ncxprogramming.com/contactus")!) {
                Image(systemName: "link.circle")
                Text("Contact Us")
            }
                .frame(maxWidth: UIScreen.main.bounds.width-50)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
