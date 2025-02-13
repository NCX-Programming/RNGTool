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
    @State private var showCredits = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        GeometryReader { geometry in
        Form {
            #if os(iOS)
            HStack() {
                Image("AltIcon").resizable()
                    .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                VStack(alignment: .leading) {
                    Text("RNGTool")
                    Text("Version \(appVersionString) (\(buildNumber))")
                        .foregroundColor(.secondary)
                    Text(copyright)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
            #endif
            #if os(watchOS)
            VStack(alignment: .leading) {
                Text("RNGTool")
                Text("Version \(appVersionString) (\(buildNumber))")
                    .foregroundColor(.secondary)
            }
            #endif
            Section() {
                Button(action:{
                    openURL(URL(string: "https://github.com/NCX-Programming")!)
                }) {
                    Label("Our GitHub", image: "GitHub")
                        .foregroundColor(.primary)
                }
                Button(action:{
                    openURL(URL(string: "https://github.com/NCX-Programming/RNGTool")!)
                }) {
                    Label("This Project", image: "GitHub")
                        .foregroundColor(.primary)
                }
                Button(action:{
                    openURL(URL(string: "https://ncxprogramming.com/contactus")!)
                }) {
                    Label {
                        Text("Contact Us")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "link.circle.fill").resizable()
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 32, height: 32)
                    }
                }
                Button(action:{
                    showCredits = true
                }) {
                    Label {
                        Text("Credits")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "person.circle.fill").resizable()
                            .foregroundColor(.accentColor)
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 32, height: 32)
                    }
                }
            }
        }
        }
        .padding(.horizontal, 3)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCredits, content: {
            AboutCredits()
            #if os(watchOS)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { self.showCredits = false }
                }
            })
            #endif
        })
    }
}

struct AboutCredits: View {
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { geometry in
        NavigationView {
            ScrollView {
                VStack(alignment: .center) {
                    Group {
                        Text("NCX-Programming")
                                .font(.title)
                                .padding(.bottom, 8)
                        Text("Programming and Design")
                            .font(.title3)
                        Button(action:{
                            openURL(URL(string: "https://github.com/NinjaCheetah")!)
                        }) {
                            Text("NinjaCheetah")
                        }
                        Text("Writing and Web Work")
                            .font(.title3)
                        Button(action:{
                            openURL(URL(string: "https://github.com/rvtr")!)
                        }) {
                            Text("rvtr")
                        }
                    }
                    Divider().frame(width: geometry.size.width - (geometry.size.width / 6))
                    Group {
                        Text("Resources")
                                .font(.title)
                                .padding(.bottom, 8)
                                .padding(.top, 6)
                        Text("SF Symbols provided by Apple")
                            .font(.title3)
                        Button(action:{
                            openURL(URL(string: "https://developer.apple.com/sf-symbols/")!)
                        }) {
                            Text("SF Symbols")
                        }
                        Text("GitHub's logo is property of GitHub Inc")
                            .font(.title3)
                        Button(action:{
                            openURL(URL(string: "https://github.com/logos")!)
                        }) {
                            Text("GitHub Branding")
                        }
                        Text("Card and Dice assets")
                            .font(.title3)
                        Button(action:{
                            openURL(URL(string: "https://github.com/NinjaCheetah")!)
                        }) {
                            Text("NinjaCheetah")
                        }
                    }
                }
            }
            #if os(iOS)
            .navigationBarTitle("Credits")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            #endif
        }
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
        AboutCredits()
    }
}
