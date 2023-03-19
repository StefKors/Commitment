//
//  SwiftUIViewDebugging.swift
//  Commitment
//
//  Created by Stef Kors on 10/03/2023.
//

import SwiftUI

// source: https://www.swiftbysundell.com/articles/building-swiftui-debugging-utilities/


/// Don't forget about: `let _ = Self._printChanges()`

extension View {
    func debugAction(_ closure: () -> Void) -> Self {
#if DEBUG
        closure()
#endif

        return self
    }
}

extension View {
    func debugPrint(_ value: Any) -> Self {
        debugAction { print(value) }
    }

    func debugType() -> Self {
        debugAction { print(Mirror(reflecting: self).subjectType) }
    }
}

extension View {



}

extension View {
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
#if DEBUG
        return modifier(self)
#else
        return self
#endif
    }
}

extension View {
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }

    func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }
}
