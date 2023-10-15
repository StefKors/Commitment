//
//  Sequence+Sorted.swift
//  Commitment
//
//  Created by Stef Kors on 15/10/2023.
//  source: https://www.swiftbysundell.com/articles/sorting-swift-collections/

import Foundation

struct SortDescriptor<Value> {
    var comparator: (Value, Value) -> ComparisonResult
}

extension SortDescriptor {
    static func keyPath<T: Comparable>(_ keyPath: KeyPath<Value, T>) -> Self {
        Self { rootA, rootB in
            let valueA = rootA[keyPath: keyPath]
            let valueB = rootB[keyPath: keyPath]

            guard valueA != valueB else {
                return .orderedSame
            }

            return valueA < valueB ? .orderedAscending : .orderedDescending
        }
    }
}

enum SortOrder {
    /// Up, Increasing in size
    case ascending
    /// Down, Decreasing in size
    case descending
}

extension Sequence {
    /// Sorting Convinience, defaults to ordered as ascending
    ///
    /// For example:
    /// ```
    /// func sortArticlesByCategory(_ articles: [Article]) -> [Article] {
    ///   articles.sorted(using: .keyPath(\.category), .keyPath(\.title))
    /// }
    ///
    /// - Parameters:
    ///   - descriptors: keypaths to sort on, for example: `.keyPath(\.category), .keyPath(\.title)`
    ///   - order: sort order, defaults to ascending
    /// - Returns: sorted sequence
    func sorted(using descriptors: SortDescriptor<Element>..., order: SortOrder = .ascending) -> [Element] {
        sorted(using: descriptors, order: order)
    }
}

extension Sequence {
    func sorted(using descriptors: [SortDescriptor<Element>],
                order: SortOrder) -> [Element] {
        sorted { valueA, valueB in
            for descriptor in descriptors {
                let result = descriptor.comparator(valueA, valueB)

                switch result {
                case .orderedSame:
                    // Keep iterating if the two elements are equal,
                    // since that'll let the next descriptor determine
                    // the sort order:
                    break
                case .orderedAscending:
                    return order == .ascending
                case .orderedDescending:
                    return order == .descending
                }
            }

            // If no descriptor was able to determine the sort
            // order, we'll default to false (similar to when
            // using the '<' operator with the built-in API):
            return false
        }
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

extension Sequence {
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] {
        sorted { a, b in
            comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
