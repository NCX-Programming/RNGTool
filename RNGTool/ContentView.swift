//
//  ContentView.swift
//  RNGTool
//
//  Created by Campbell on 8/30/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsData: SettingsData
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumberStr: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    var body: some View {
        ModeList()
            .frame(minWidth: 700, minHeight: 300)
            .onAppear {
                if(settingsData.checkUpdatesOnStartup) {
                    checkForUpdates { result in
                        DispatchQueue.global().async {
                            switch result {
                                case .success(let value):
                                    print(value)
                                    print("API access complete!")
                                    let tagName: String = value.tagName
                                    print(tagName)
                                    let tagNameSplit = tagName.split(separator: "-")
                                    let tagStripped: Int = tagNameSplit.last.map{ Int($0) ?? 1 } ?? 1
                                    print(tagStripped)
                                    let tagMarketVer = tagNameSplit.first.map{ String($0) }
                                    print(tagMarketVer!)
                                    let buildNumber: Int = Int(buildNumberStr) ?? 0
                                    print("Current version: \(buildNumber), latest version: \(tagStripped).")
                                    DispatchQueue.main.sync {
                                        if(tagStripped > buildNumber) {
                                            OpenWindows.Update.open()
                                        }
                                    }
                                case .failure(let error): print(error)
                            }
                        }
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
