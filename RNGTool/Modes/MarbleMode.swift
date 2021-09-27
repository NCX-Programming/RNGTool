//
//  MarbleMode.swift
//  RNGTool
//
//  Created by Campbell on 9/25/21.
//

import SwiftUI

struct MarbleMode: View {
    @State private var numOfMarbles = 1
    @State private var showCopy = false
    @State private var showMarbles = false
    @State private var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Marble Mode")
                        .font(.title)
                    Text("Generate multiple numbers or letters using dice")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Divider()
                    HStack(){
                        if(showMarbles){
                            ZStack() {
                                Text("")
                                    .font(.title)
                                Circle()
                                    .stroke(Color.primary, lineWidth: 3)
                            }
                            .frame(width: 64, height: 64)
                            if(numOfMarbles>1){
                                ZStack() {
                                    Text("")
                                        .font(.title)
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 3)
                                }
                                .frame(width: 64, height: 64)
                                if(numOfMarbles>2){
                                    ZStack() {
                                        Text("")
                                            .font(.title)
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 3)
                                    }
                                    .frame(width: 64, height: 64)
                                    if(numOfMarbles>3){
                                        ZStack() {
                                            Text("")
                                                .font(.title)
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 3)
                                        }
                                        .frame(width: 64, height: 64)
                                        if(numOfMarbles>4){
                                            ZStack() {
                                                Text("")
                                                    .font(.title)
                                                Circle()
                                                    .stroke(Color.primary, lineWidth: 3)
                                            }
                                            .frame(width: 64, height: 64)
                                            if(numOfMarbles>5){
                                                ZStack() {
                                                    Text("")
                                                        .font(.title)
                                                    Circle()
                                                        .stroke(Color.primary, lineWidth: 3)
                                                }
                                                .frame(width: 64, height: 64)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.leading, 12)
        }
    }
}

struct MarbleMode_Previews: PreviewProvider {
    static var previews: some View {
        MarbleMode()
    }
}
