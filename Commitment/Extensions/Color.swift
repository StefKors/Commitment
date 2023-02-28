//
//  Color.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import AppKit

extension Color {
    /// The user's current accent color preference. Users set the accent color in the General pane of system preferences. Do not make assumptions about the color space associated with this color. Crudely bridged to SwiftUI See [controlAccentColor](https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor)
    static var controlAccentColor: Color {
        Color(nsColor: .controlAccentColor)
    }
}
