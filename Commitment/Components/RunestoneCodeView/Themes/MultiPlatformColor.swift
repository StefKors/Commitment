//
//  MultiPlatformColor.swift
//  Commitment
//
//  Created by Stef Kors on 14/02/2023.
//
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif
import Foundation

#if os(iOS)
public extension UIColor {
    convenience init(namedInModule name: String) {
        self.init(named: name, in: .main, compatibleWith: nil)!
    }
}
#else
public extension NSColor {
    convenience init(namedInModule name: String) {
        self.init(named: name, bundle: .main)!
    }
}
#endif
