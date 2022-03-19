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
    @State var entry: TaskEntry? = nil
    
    var body: some View {
        Button("Check for Updates...") {
            checkForUpdates()
            print("API access complete!")
            let tagName: String = entry?.tagName ?? "vX.X-25565"
            print(tagName)
            let tagNameSplit = tagName.split(separator: "-")
            print(tagNameSplit)
            let tagStripped: Int = tagNameSplit.last.map{ Int($0) ?? 25565 } ?? 25565
            print(tagStripped)
        }
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
