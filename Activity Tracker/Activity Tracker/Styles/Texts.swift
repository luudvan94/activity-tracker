//
//  Texts.swift
//  Activity Tracker
//
//  Created by luu van on 11/9/21.
//

import SwiftUI

extension Text {
    static func header(_ text: String) -> some View {
        Text(text).font(.title2)
    }
    
    static func regular(_ text: String) -> some View {
        Text(text)
    }
    
    static func tag(_ text: String) -> some View {
        Text(text).font(.body)
    }
}
