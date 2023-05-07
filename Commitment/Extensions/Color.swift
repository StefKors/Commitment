//
//  Color.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import AppKit

extension Color {

    @available(macOS 10.10, *)
    static var labelColor: Color {
        Color(nsColor: .labelColor)
    }

    @available(macOS 10.10, *)
    static var secondaryLabelColor: Color {
        Color(nsColor: .secondaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var tertiaryLabelColor: Color {
        Color(nsColor: .tertiaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var quaternaryLabelColor: Color {
        Color(nsColor: .quaternaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var linkColor: Color {
        Color(nsColor: .linkColor)
    }

    @available(macOS 10.10, *)
    static var placeholderTextColor: Color {
        Color(nsColor: .placeholderTextColor)
    }

    static var windowFrameTextColor: Color {
        Color(nsColor: .windowFrameTextColor)
    }

    static var selectedMenuItemTextColor: Color {
        Color(nsColor: .selectedMenuItemTextColor)
    }

    static var alternateSelectedControlTextColor: Color {
        Color(nsColor: .alternateSelectedControlTextColor)
    }

    static var headerTextColor: Color {
        Color(nsColor: .headerTextColor)
    }

    @available(macOS 10.14, *)
    static var separatorColor: Color {
        Color(nsColor: .separatorColor)
    }

    static var gridColor: Color {
        Color(nsColor: .gridColor)
    }

    static var windowBackgroundColor: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    @available(macOS 10.8, *)
    static var underPageBackgroundColor: Color {
        Color(nsColor: .underPageBackgroundColor)
    }

    static var controlBackgroundColor: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var selectedContentBackgroundColor: Color {
        Color(nsColor: .selectedContentBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedContentBackgroundColor: Color {
        Color(nsColor: .unemphasizedSelectedContentBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var alternatingContentBackgroundColors: [Color] {
        return NSColor.alternatingContentBackgroundColors.map { color in
            Color(nsColor: color)
        }
    }

    @available(macOS 10.13, *)
    static var findHighlightColor: Color {
        Color(nsColor: .findHighlightColor)
    }

    static var textColor: Color {
        Color(nsColor: .textColor)
    }

    static var textBackgroundColor: Color {
        Color(nsColor: .textBackgroundColor)
    }

    static var selectedTextColor: Color {
        Color(nsColor: .selectedTextColor)
    }

    static var selectedTextBackgroundColor: Color {
        Color(nsColor: .selectedTextBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedTextBackgroundColor: Color {
        Color(nsColor: .unemphasizedSelectedTextBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedTextColor: Color {
        Color(nsColor: .unemphasizedSelectedTextColor)
    }

    static var controlColor: Color {
        Color(nsColor: .controlColor)
    }

    static var controlTextColor: Color {
        Color(nsColor: .controlTextColor)
    }

    static var selectedControlColor: Color {
        Color(nsColor: .selectedControlColor)
    }

    static var selectedControlTextColor: Color {
        Color(nsColor: .selectedControlTextColor)
    }

    static var disabledControlTextColor: Color {
        Color(nsColor: .disabledControlTextColor)
    }

    static var keyboardFocusIndicatorColor: Color {
        Color(nsColor: .keyboardFocusIndicatorColor)
    }

    @available(macOS 10.12.2, *)
    static var scrubberTexturedBackground: Color {
        Color(nsColor: .scrubberTexturedBackground)
    }

    @available(macOS 10.10, *)
    static var systemRed: Color {
        Color(nsColor: .systemRed)
    }

    @available(macOS 10.10, *)
    static var systemGreen: Color {
        Color(nsColor: .systemGreen)
    }

    @available(macOS 10.10, *)
    static var systemBlue: Color {
        Color(nsColor: .systemBlue)
    }

    @available(macOS 10.10, *)
    static var systemOrange: Color {
        Color(nsColor: .systemOrange)
    }

    @available(macOS 10.10, *)
    static var systemYellow: Color {
        Color(nsColor: .systemYellow)
    }

    @available(macOS 10.10, *)
    static var systemBrown: Color {
        Color(nsColor: .systemBrown)
    }

    @available(macOS 10.10, *)
    static var systemPink: Color {
        Color(nsColor: .systemPink)
    }

    @available(macOS 10.10, *)
    static var systemPurple: Color {
        Color(nsColor: .systemPurple)
    }

    @available(macOS 10.10, *)
    static var systemGray: Color {
        Color(nsColor: .systemGray)
    }

    @available(macOS 10.12, *)
    static var systemTeal: Color {
        Color(nsColor: .systemTeal)
    }

    @available(macOS 10.15, *)
    static var systemIndigo: Color {
        Color(nsColor: .systemIndigo)
    }

    @available(macOS 10.12, *)
    static var systemMint: Color {
        Color(nsColor: .systemMint)
    }

    @available(macOS 12.0, *)
    static var systemCyan: Color {
        Color(nsColor: .systemCyan)
    }

    /// The user's current accent color preference. Users set the accent color in the General pane of system preferences. Do not make assumptions about the color space associated with this color. Crudely bridged to SwiftUI See [controlAccentColor](https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor)
    /** A dynamic color that reflects the user's current preferred accent color. This color automatically updates when the accent color preference changes. Do not make assumptions about the color space of this color, which may change across releases. */
    @available(macOS 10.14, *)
    static var controlAccentColor: Color {
        Color(nsColor: .controlAccentColor)
    }

    // static var currentControlTint: Color {
    //     Color(nsColor: .currentControlTint)
    // }

    // @available(macOS, introduced: 10.0, deprecated: 11.0, message: "NSControlTint does not describe the full range of available control accent colors. Use +[NSColor controlAccentColor] instead.")
    // public /*not inherited*/ init(for controlTint: NSControlTint)

    static var highlightColor: Color {
        Color(nsColor: .highlightColor)
    }

    static var shadowColor: Color {
        Color(nsColor: .shadowColor)
    }

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
