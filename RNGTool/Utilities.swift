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
