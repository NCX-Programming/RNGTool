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
    
    enum CodingKeys: String, CodingKey {
      case id, tagName = "tag_name", name
    }
}

enum InvalidHTTPError: Error {
    case invalid
}

func checkForUpdates(completionHandler: @escaping (Result<TaskEntry, Error>) -> Void) {
    guard let url = URL(string: "https://api.github.com/repos/NCX-Programming/RNGTool/releases/latest") else {
        print("Invalid URL")
        return
    }
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard case .none = error else { return }
        
        guard let data = data else {
            print("Data error.")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completionHandler(.failure(InvalidHTTPError.invalid))
            return
        }
        
        let decoded: Result<TaskEntry, Error> = Result(catching: { try JSONDecoder().decode(TaskEntry.self, from: data) })
        completionHandler(decoded)
    }.resume()
}

struct UpdateCheck: View {
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumberStr: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    @Environment(\.openURL) var openURL
    @State private var tagMarketVer: String?
    @State private var yesUpdate = false
    @State private var showSpinner = true
    @State private var updateString = ""
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                if showSpinner {
                    ProgressView("Checking for updates...")
                }
                Text(updateString)
                    .onAppear {
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
                                        tagMarketVer = tagNameSplit.first.map{ String($0) }
                                        print(tagMarketVer!)
                                        let buildNumber: Int = Int(buildNumberStr) ?? 0
                                        print("Current version: \(buildNumber), latest version: \(tagStripped).")
                                        DispatchQueue.main.sync {
                                            if(tagStripped > buildNumber) {
                                                showSpinner = false; yesUpdate = true
                                                updateString = "New version available! (RNGTool \(tagMarketVer!))"
                                            }
                                            else { showSpinner = false; updateString = "You're up to date! (RNGTool \(appVersionString))" }
                                        }
                                    case .failure(let error): print(error)
                                }
                            }
                        }
                    }
            }
        }
        .alert(isPresented: $yesUpdate) {
            Alert(
                title: Text("Update available!"),
                message: Text("RNGTool \(tagMarketVer!) is available! You're currently running RNGTool \(appVersionString)."),
                primaryButton: .default(Text("View Release")){
                    openURL(URL(string: "https://github.com/NCX-Programming/RNGTool/releases/latest")!)
                },
                secondaryButton: .cancel()
            )
        }
    }
}
