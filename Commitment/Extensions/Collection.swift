//
//  Collection.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import Foundation

extension Collection {
    
    /// A Boolean value indicating whether the collection is not empty, i.e. contains a value.
    /// Uses `!self.isEmpty` internally.
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Identifiable {
    func first(with id: Self.Element.ID?) -> Self.Element? {
        return self.first { item -> Bool in
            guard let id else { return false }
            return item.id == id
        }
    }
}

extension Collection {
    /// The parallel async version of map.
    /// source: https://gist.github.com/DougGregor/92a2e4f6e11f6d733fb5065e9d1c880f
    /// - Parameters:
    ///   - requestedParallelism: amount of parallel requests, defaults to 2
    ///   - transform: the map transform function
    /// - Returns: results
    func parallelMap<T>(
        parallelism requestedParallelism: Int? = nil,
        _ transform: @escaping (Element) async throws -> T
    ) async throws -> [T] {
        let defaultParallelism = 2
        let parallelism = requestedParallelism ?? defaultParallelism

        let n = self.count
        if n == 0 {
            return []
        }

        return try await withThrowingTaskGroup(of: (Int, T).self) { group in
            var result = Array<T?>(repeatElement(nil, count: n))

            var i = self.startIndex
            var submitted = 0

            func submitNext() async throws {
                if i == self.endIndex { return }

                group.addTask { [submitted, i] in
                    let value = try await transform(self[i])
                    return (submitted, value)
                }
                submitted += 1
                formIndex(after: &i)
            }

            // submit first initial tasks
            for _ in 0..<parallelism {
                try await submitNext()
            }

            // as each task completes, submit a new task until we run out of work
            while let (index, taskResult) = try await group.next() {
                result[index] = taskResult

                try Task.checkCancellation()
                try await submitNext()
            }

            assert(result.count == n)
            return Array(result.compactMap { $0 })
        }
    }

    /// The parallel async version of map.
    /// source: https://gist.github.com/DougGregor/92a2e4f6e11f6d733fb5065e9d1c880f
    /// - Parameters:
    ///   - requestedParallelism: amount of parallel requests, defaults to 2
    ///   - transform: the map transform function
    /// - Returns: results
    func parallelMap<T>(
        parallelism requestedParallelism: Int? = nil,
        _ transform: @escaping (Element) async -> T
    ) async -> [T] {
        let defaultParallelism = 2
        let parallelism = requestedParallelism ?? defaultParallelism

        let n = self.count
        if n == 0 {
            return []
        }

        return await withTaskGroup(of: (Int, T).self) { group in
            var result = Array<T?>(repeatElement(nil, count: n))

            var i = self.startIndex
            var submitted = 0

            func submitNext() async {
                if i == self.endIndex { return }

                group.addTask { [submitted, i] in
                    let value = await transform(self[i])
                    return (submitted, value)
                }
                submitted += 1
                formIndex(after: &i)
            }

            // submit first initial tasks
            for _ in 0..<parallelism {
                await submitNext()
            }

            // as each task completes, submit a new task until we run out of work
            while let (index, taskResult) = await group.next() {
                result[index] = taskResult

                // Might not be a good idea to remove throws here? we will, see later...
//                Task.checkCancellation()
                await submitNext()
            }

            assert(result.count == n)
            return Array(result.compactMap { $0 })
        }
    }
}
