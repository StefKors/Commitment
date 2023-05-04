// https://gist.github.com/kristopherjohnson/f301434cdecc28950041
import Foundation

#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// Return string value currently on clipboard
func getPasteboardContents() -> String? {
#if os(iOS)
    let pasteboard = UIPasteboard.generalPasteboard()
    return pasteboard.string
#else
    return NSPasteboard.general.string(forType: .rtf)
#endif
}

/// Write a string value to the pasteboard
func copyToPasteboard(text: String) {
#if os(iOS)
    let pasteboard = UIPasteboard.generalPasteboard()
    pasteboard.string = text
#else
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
#endif
}
