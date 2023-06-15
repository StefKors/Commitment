//
//  Color.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import AppKit

extension Color {
    fileprivate var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard let hsbColor = NSColor(self).usingColorSpace(NSColorSpace.deviceRGB) else {
            return (r, g, b, o)
        }

        r = hsbColor.redComponent
        g = hsbColor.greenComponent
        b = hsbColor.blueComponent
        o = hsbColor.alphaComponent

        return (r, g, b, o)
    }

    /// Adjust color lighter by percentage e.g. `30` is `30%`
    /// - Parameter percentage: expressed in number
    /// - Returns: Adjusted color
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    /// Adjust color darker by percentage e.g. `30` is `30%`
    /// - Parameter percentage: expressed in number
    /// - Returns: Adjusted color
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    /// Adjust color by percentage e.g. `30` is `30%`. Negative numbers adjust color darker, Positive numbers adjust lighter.
    /// - Parameter percentage: expressed in number
    /// - Returns: Adjusted color
    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
