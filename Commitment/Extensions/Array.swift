//
//  Array.swift
//  Commitment
//
//  Created by Stef Kors on 27/02/2023.
//

import Foundation


extension Array where Element: Equatable {
    /// Helper method: Count instances of element in array
    /// - Parameter element: element to count
    /// - Returns: number of instances
    private func countInstances(of element: Element) -> Int {
        return reduce(0) { $0 + ($1 == element ? 1 : 0) }
    }

    /// Sort by ordered array method
    /// source: https://stackoverflow.com/a/40016429/3199999
    /// - Parameter orderArray: array order sample
    /// - Returns: full array starting with the items from the `orderArray`
    func sortBy(orderArray: [Element]) -> [Element] {
        // Construct sorted array based on elements in orderArray
        return orderArray
            .reduce([], { partialResult, matching in
                let instances = Array(repeating: matching, count: countInstances(of: matching))
                let filter = filter { !orderArray.contains($0) }
                return partialResult + instances + filter
            })
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
