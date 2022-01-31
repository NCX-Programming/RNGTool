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
        GeometryReader { geometry in
        Form {
            HStack() {
                ZStack() {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                        .foregroundColor(Color.accentColor)
                    Image("LaunchIcon").resizable()
                        .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                }
                VStack(alignment: .leading) {
                    Text("RNGTool")
                    Text(copyright)
                        .foregroundColor(.secondary)
                    Text("Version \(appVersionString) (\(buildNumber))")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
            Section(header: Text("Links")) {
                Link(destination: URL(string: "https://github.com/NCX-Programming")!) {
                    HStack() {
                        Image("GitHub")
                            .foregroundColor(.accentColor)
                        Text("Our GitHub")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        /*
            Link(destination: URL(string:"https://github.com/NCX-Programming")!) {
                Image(systemName: "link.circle")
                Text("Our GitHub")
            }
                .frame(maxWidth: geometry.size.width-(geometry.size.width / 4))
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
            Link(destination: URL(string:"https://github.com/NCX-Programming/RNGTool")!) {
                Image(systemName: "link.circle")
                Text("This Project")
            }
                .frame(maxWidth: geometry.size.width-(geometry.size.width / 4))
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
            Link(destination: URL(string:"https://ncxprogramming.com/contactus")!) {
                Image(systemName: "link.circle")
                Text("Contact Us")
            }
            .frame(maxWidth: geometry.size.width-(geometry.size.width / 4))
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 1))
            Spacer()
                .padding(.top, 6)
            Group {
                Text("Credits")
                        .font(.title2)
                Text("Programming and Design")
                    .font(.title3)
                Text("NinjaCheetah")
                    .foregroundColor(.secondary)
                Text("Writing and Web Work")
                    .font(.title3)
                Text("IanSkinner1982")
                    .foregroundColor(.secondary)
                Text("SF Symbols provided by Apple")
                    .font(.title3)
            }
        }*/
        }
        .padding(.horizontal, 3)
        .navigationTitle("About RNGTool")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
