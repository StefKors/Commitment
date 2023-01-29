//
//  Collection.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Identifiable {
    func first(with id: Self.Element.ID?) -> Self.Element? {
        print("finding first")
        return self.first { item -> Bool in
            guard let id else { return false }
            return item.id == id
        }
    }
}
