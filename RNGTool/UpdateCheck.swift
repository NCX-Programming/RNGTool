//
//  UpdateCheck.swift
//  RNGTool
//
//  Created by Campbell on 3/18/22.
//

import Foundation
import SwiftUI

struct TaskEntry: Codable {
    let id: Int
    let tagName: String
    let name: String
}

struct UpdateCheck: View {
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumberStr: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    @State var entry: TaskEntry? = nil
    @State private var tagMarketVer: String?
    @State private var noUpdate = false
    @State private var yesUpdate = false
    
    var body: some View {
        Button("Check for Updates...") {
            checkForUpdates()
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("API access complete!")
                let tagName: String = entry?.tagName ?? "vX.X-25565"
                print(tagName)
                let tagNameSplit = tagName.split(separator: "-")
                let tagStripped: Int = tagNameSplit.last.map{ Int($0) ?? 25565 } ?? 25565
                print(tagStripped)
                tagMarketVer = tagNameSplit.first.map{ String($0) }
                print(tagMarketVer!)
                let buildNumber: Int = Int(buildNumberStr) ?? 0
                print("Current version: \(buildNumber), latest version: \(tagStripped).")
                //if(tagStripped > buildNumber) { yesUpdate = true }
                //else { updateAlert.noUpdate = true }
                DispatchQueue.main.sync {
                    if(tagStripped > buildNumber) { yesUpdate = true }
                    else { noUpdate = true }
                }
            }
        }
        .alert(isPresented: $noUpdate) {
            Alert(
                title: Text("Up to date!"),
                message: Text("You're running the latest version of RNGTool. \(appVersionString)")
            )
        }
        /*.alert(isPresented: $yesUpdate) {
            Alert(
                title: Text("Update available!"),
                message: Text("RNGTool version \(tagMarketVer!) is available, and you're running version \(appVersionString)."),
                primaryButton: .default(Text("Confirm")){
                    print("Ok")
                },
                secondaryButton: .cancel()
            )
        }*/
    }
    func checkForUpdates() {
        guard let url = URL(string: "https://api.github.com/repos/NCX-Programming/RNGTool/releases/latest") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // TODO: Handle data task error
                print("Task error.")
                return
            }
            
            guard let data = data else {
                // TODO: Handle this
                print("Data error.")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let response = try decoder.decode(TaskEntry.self, from: data)
                
                    DispatchQueue.main.async {
                        self.entry = response
                    }
            } catch {
                // TODO: Handle decoding error
                print("Decoding error.")
                print(error)
            }
        }.resume()
    }
}
