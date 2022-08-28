//
//  NumKeyboard.swift
//  RNGToolWrist WatchKit Extension
//
//  Created by Campbell on 8/23/22.
//

import SwiftUI
import WatchKit

struct NumKeyboard: View {
    @Binding var targetNumber: Int
    @State private var currentNumberStr = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .trailing) {
                    Text(currentNumberStr)
                        .font(.title3)
                        .padding(.horizontal, 5.0)
                    HStack {
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "1" }
                            else { currentNumberStr += "1" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("1")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "2" }
                            else { currentNumberStr += "2" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("2")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "3" }
                            else { currentNumberStr += "3" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("3")
                        }
                    }
                    HStack {
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "4" }
                            else { currentNumberStr += "4" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("4")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "5" }
                            else { currentNumberStr += "5" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("5")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "6" }
                            else { currentNumberStr += "6" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("6")
                        }
                    }
                    HStack {
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "7" }
                            else { currentNumberStr += "7" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("7")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "8" }
                            else { currentNumberStr += "8" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("8")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr == "0") { currentNumberStr = "9" }
                            else { currentNumberStr += "9" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("9")
                        }
                    }
                    HStack {
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            if(currentNumberStr != "0") { currentNumberStr += "0" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Text("0")
                        }
                        Button {
                            WKInterfaceDevice.current().play(.click)
                            currentNumberStr.remove(at: currentNumberStr.index(before: currentNumberStr.endIndex))
                            if(currentNumberStr == "") { currentNumberStr = "0" }
                            targetNumber = Int(currentNumberStr.prefix(19)) ?? 0
                        } label: {
                            Image(systemName: "delete.left")
                        }
                    }
                }
                .font(.system(size: 18, weight: .regular, design: .rounded))
            }
            .onAppear {
                currentNumberStr = "\(targetNumber)"
            }
        }
    }
}

struct NumKeyboard_Previews: PreviewProvider {
    @State static var exampleNum = 0
    
    static var previews: some View {
        NumKeyboard(targetNumber: $exampleNum)
    }
}
