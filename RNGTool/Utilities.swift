//
//  Utilities.swift
//  RNGTool
//
//  Created by Campbell on 11/24/21.
//

import Foundation
import SwiftUI

func copyToClipboard(item: String){
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(item, forType: NSPasteboard.PasteboardType.string)
    var clipboardItems: [String] = []
    for element in pasteboard.pasteboardItems! {
        if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
            clipboardItems.append(str)
        }
    }
}

func resetNumSet(){
    @AppStorage("maxNumberDefault") var maxNumberDefault = 100
    @AppStorage("minNumberDefault") var minNumberDefault = 0

    maxNumberDefault = 100
    minNumberDefault = 0
}

func resetDiceSet(){
    @AppStorage("forceSixSides") var forceSixSides = false
    @AppStorage("allowDiceImages") var allowDiceImages = true
    
    forceSixSides = false
    allowDiceImages = true
}

func resetCardSet(){
    @AppStorage("showPoints") var showPoints = false
    @AppStorage("aceValue") var aceValue = 1
    @AppStorage("useFaces") var useFaces = true
    
    showPoints = false
    aceValue = 1
    useFaces = true
}

func resetMarbleSet(){
    @AppStorage("showLetterList") var showLetterList = false
    
    showLetterList = false
}
