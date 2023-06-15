//
//  Color.swift
//  ColorKit
//
//  Created by Stef Kors on 09/06/2023.
//

import SwiftUI

extension Color {
#if os(macOS)
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

#else

    /* Some colors that are used by system elements and applications.
     * These return named colors whose values may vary between different contexts and releases.
     * Do not make assumptions about the color spaces or actual colors used.
     */
    @available(iOS 7.0, *)
    static var systemRed: Color {
        Color(uiColor: UIColor.systemRed)
    }

    @available(iOS 7.0, *)
    static var systemGreen: Color {
        Color(uiColor: UIColor.systemGreen)
    }

    @available(iOS 7.0, *)
    static var systemBlue: Color {
        Color(uiColor: UIColor.systemBlue)
    }

    @available(iOS 7.0, *)
    static var systemOrange: Color {
        Color(uiColor: UIColor.systemOrange)
    }

    @available(iOS 7.0, *)
    static var systemYellow: Color {
        Color(uiColor: UIColor.systemYellow)
    }

    @available(iOS 7.0, *)
    static var systemPink: Color {
        Color(uiColor: UIColor.systemPink)
    }

    @available(iOS 9.0, *)
    static var systemPurple: Color {
        Color(uiColor: UIColor.systemPurple)
    }

    @available(iOS 7.0, *)
    static var systemTeal: Color {
        Color(uiColor: UIColor.systemTeal)
    }

    @available(iOS 13.0, *)
    static var systemIndigo: Color {
        Color(uiColor: UIColor.systemIndigo)
    }

    @available(iOS 13.0, *)
    static var systemBrown: Color {
        Color(uiColor: UIColor.systemBrown)
    }

    @available(iOS 15.0, *)
    static var systemMint: Color {
        Color(uiColor: UIColor.systemMint)
    }

    @available(iOS 15.0, *)
    static var systemCyan: Color {
        Color(uiColor: UIColor.systemCyan)
    }


    /* Shades of gray. systemGray is the base gray color.
     */
    @available(iOS 7.0, *)
    static var systemGray: Color {
        Color(uiColor: UIColor.systemGray)
    }


    /* The numbered variations, systemGray2 through systemGray6, are grays which increasingly
     * trend away from systemGray and in the direction of systemBackgroundColor.
     *
     * In UIUserInterfaceStyleLight: systemGray2 is slightly lighter than systemGray.
     *                               systemGray3 is lighter than that, and so on.
     * In UIUserInterfaceStyleDark:  systemGray2 is slightly darker than systemGray.
     *                               systemGray3 is darker than that, and so on.
     */
    @available(iOS 13.0, *)
    static var systemGray2: Color {
        Color(uiColor: UIColor.systemGray2)
    }

    @available(iOS 13.0, *)
    static var systemGray3: Color {
        Color(uiColor: UIColor.systemGray3)
    }

    @available(iOS 13.0, *)
    static var systemGray4: Color {
        Color(uiColor: UIColor.systemGray4)
    }

    @available(iOS 13.0, *)
    static var systemGray5: Color {
        Color(uiColor: UIColor.systemGray5)
    }

    @available(iOS 13.0, *)
    static var systemGray6: Color {
        Color(uiColor: UIColor.systemGray6)
    }


    /* This color represents the tint color of a view.
     *
     * Like other dynamic colors, UIColor.tintColor relies on UITraitCollection.currentTraitCollection
     * being set to a view's trait collection when it is used, so that it can resolve to that view's
     * tint color. If you use UIColor.tintColor outside a view's context, and do not resolve it
     * manually with a view's trait collection, it will return the system default tint color.
     *
     * Setting UIColor.tintColor directly to a view's tintColor property behaves the same as setting nil.
     * However, you cannot set a custom dynamic color (e.g. using +[UIColor colorWithDynamicProvider:])
     * that can resolve to UIColor.tintColor to a view's tintColor property.
     */
    @available(iOS 15.0, *)
    static var tintColor: Color {
        Color(uiColor: UIColor.tintColor)
    }


    /* Foreground colors for static text and related elements.
     */
    @available(iOS 13.0, *)
    static var label: Color {
        Color(uiColor: UIColor.label)
    }

    @available(iOS 13.0, *)
    static var secondaryLabel: Color {
        Color(uiColor: UIColor.secondaryLabel)
    }

    @available(iOS 13.0, *)
    static var tertiaryLabel: Color {
        Color(uiColor: UIColor.tertiaryLabel)
    }

    @available(iOS 13.0, *)
    static var quaternaryLabel: Color {
        Color(uiColor: UIColor.quaternaryLabel)
    }


    /* Foreground color for standard system links.
     */
    @available(iOS 13.0, *)
    static var link: Color {
        Color(uiColor: UIColor.link)
    }


    /* Foreground color for placeholder text in controls or text fields or text views.
     */
    @available(iOS 13.0, *)
    static var placeholderText: Color {
        Color(uiColor: UIColor.placeholderText)
    }


    /* Foreground colors for separators (thin border or divider lines).
     * `separatorColor` may be partially transparent, so it can go on top of any content.
     * `opaqueSeparatorColor` is intended to look similar, but is guaranteed to be opaque, so it will
     * completely cover anything behind it. Depending on the situation, you may need one or the other.
     */
    @available(iOS 13.0, *)
    static var separator: Color {
        Color(uiColor: UIColor.separator)
    }

    @available(iOS 13.0, *)
    static var opaqueSeparator: Color {
        Color(uiColor: UIColor.opaqueSeparator)
    }


    /* We provide two design systems (also known as "stacks") for structuring an iOS app's backgrounds.
     *
     * Each stack has three "levels" of background colors. The first color is intended to be the
     * main background, farthest back. Secondary and tertiary colors are layered on top
     * of the main background, when appropriate.
     *
     * Inside of a discrete piece of UI, choose a stack, then use colors from that stack.
     * We do not recommend mixing and matching background colors between stacks.
     * The foreground colors above are designed to work in both stacks.
     *
     * 1. systemBackground
     *    Use this stack for views with standard table views, and designs which have a white
     *    primary background in light mode.
     */
    @available(iOS 13.0, *)
    static var systemBackground: Color {
        Color(uiColor: UIColor.systemBackground)
    }

    @available(iOS 13.0, *)
    static var secondarySystemBackground: Color {
        Color(uiColor: UIColor.secondarySystemBackground)
    }

    @available(iOS 13.0, *)
    static var tertiarySystemBackground: Color {
        Color(uiColor: UIColor.tertiarySystemBackground)
    }


    /* 2. systemGroupedBackground
     *    Use this stack for views with grouped content, such as grouped tables and
     *    platter-based designs. These are like grouped table views, but you may use these
     *    colors in places where a table view wouldn't make sense.
     */
    @available(iOS 13.0, *)
    static var systemGroupedBackground: Color {
        Color(uiColor: UIColor.systemGroupedBackground)
    }

    @available(iOS 13.0, *)
    static var secondarySystemGroupedBackground: Color {
        Color(uiColor: UIColor.secondarySystemGroupedBackground)
    }

    @available(iOS 13.0, *)
    static var tertiarySystemGroupedBackground: Color {
        Color(uiColor: UIColor.tertiarySystemGroupedBackground)
    }


    /* Fill colors for UI elements.
     * These are meant to be used over the background colors, since their alpha component is less than 1.
     *
     * systemFillColor is appropriate for filling thin and small shapes.
     * Example: The track of a slider.
     */
    @available(iOS 13.0, *)
    static var systemFill: Color {
        Color(uiColor: UIColor.systemFill)
    }


    /* secondarySystemFillColor is appropriate for filling medium-size shapes.
     * Example: The background of a switch.
     */
    @available(iOS 13.0, *)
    static var secondarySystemFill: Color {
        Color(uiColor: UIColor.secondarySystemFill)
    }


    /* tertiarySystemFillColor is appropriate for filling large shapes.
     * Examples: Input fields, search bars, buttons.
     */
    @available(iOS 13.0, *)
    static var tertiarySystemFill: Color {
        Color(uiColor: UIColor.tertiarySystemFill)
    }


    /* quaternarySystemFillColor is appropriate for filling large areas containing complex content.
     * Example: Expanded table cells.
     */
    @available(iOS 13.0, *)
    static var quaternarySystemFill: Color {
        Color(uiColor: UIColor.quaternarySystemFill)
    }


    /* lightTextColor is always light, and darkTextColor is always dark, regardless of the current UIUserInterfaceStyle.
     * When possible, we recommend using `labelColor` and its variants, instead.
     */
    static var lightText: Color {
        Color(uiColor: UIColor.lightText)
    } // for a dark background

    static var darkText: Color {
        Color(uiColor: UIColor.darkText)
    } // for a light background


    /* groupTableViewBackgroundColor is now the same as systemGroupedBackgroundColor.
     */
    @available(iOS, introduced: 2.0, deprecated: 13.0)
    static var groupTableViewBackground: Color {
        Color(uiColor: UIColor.groupTableViewBackground)
    }
#endif
}
