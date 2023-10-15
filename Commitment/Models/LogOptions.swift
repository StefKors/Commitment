//
//  LogOptions.swift
//  Commitment
//
//  Created by Stef Kors on 27/02/2023.
//

import Foundation

/// A set of options used by the git log operation
class LogOptions: ArgumentConvertible {

    /// Returns the default options for the log operation
    static var `default`: LogOptions {
        return LogOptions()
    }

    init(compareReference: ReferenceComparator? = nil) {
        self.compareReference = compareReference
    }

    /// A number of commits to load. Default value is not specified that means there is not limit.
    var limit: UInt?

    /// Limit the commits output to ones with author/committer header lines that match the specified pattern (regular expression).
    var author: String?

    /// Show commits more recent than a specific date.
    var after: Date?

    /// Show commits older than a specific date.
    var before: Date?

    /// A reference (branch) to list log records for.
    ///
    /// When specified it is equivalent to the following command: git log `<remote_name>/<reference_name>`
    var reference: Reference?

    struct ReferenceComparator: ArgumentConvertible {
        var lhsReferenceName: String
        var rhsReferenceName: String

        func toArguments() -> [String] {
            return ["\(lhsReferenceName)..\(rhsReferenceName)"]
        }
    }

    var compareReference: ReferenceComparator?

    func toArguments() -> [String] {
        var arguments = [String]()

        if let limit = limit {
            arguments.append("-\(limit)")
        }

        if let after = after {
            arguments.append("--after=\"\(Formatter.iso8601.string(from: after))\"")
        }

        if let before = before {
            arguments.append("--before=\"\(Formatter.iso8601.string(from: before))\"")
        }

        if let author = author {
            arguments.append("--author=\"\(author)\"")
        }

        if let reference = reference {
            arguments.append(contentsOf: reference.toArguments())
        } else if let comparator = compareReference {
            arguments.append(contentsOf: comparator.toArguments())
        }

        return arguments
    }
}

// MARK: - Reference
extension LogOptions {

    struct Reference: ArgumentConvertible {

        // MARK: - Init
        init(name: String) {
            self.name = name
            self.remote = nil
        }

        init(name: String, remote: Remote) {
            self.name = name
            self.remote = remote
        }

        /// A name of a reference
        var name: String

        /// A name of a remote. If a remote is not provided
        var remote: Remote?

        /// The first remote when a remote is not provided.
        var firstRemote: Remote?

        func toArguments() -> [String] {
            if let remote = firstRemote {
                return ["\(remote.name)/\(name)"]
            } else if let remote = remote {
                return ["\(remote.name)/\(name)"]
            } else {
                return []
            }
        }
    }
}

