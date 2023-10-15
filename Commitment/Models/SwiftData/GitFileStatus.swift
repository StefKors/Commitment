//
//  GitFileStatus.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

/// Describes a single file status
public class GitFileStatus: Codable, Identifiable {

    // MARK: - Init
    internal init(path: String, state: String, sha: String? = nil, stats: GitFileStats? = nil) {
        self.path = path
        self.sha = sha
        self.stats = stats
        // self.id = UUID().uuidString
        var lhs: String
        var rhs: String
        
        if state.count > 1 {
            lhs = String(state[state.startIndex])
            rhs = String(state[state.index(state.startIndex, offsetBy: 1)])
        } else {
            lhs = ModificationState.unknown.rawValue
            rhs = ModificationState.unknown.rawValue
        }
        
        self.state = State(lhs: lhs, rhs: rhs)
    }

    public var id: String {
        self.path
    }

    /// Cleaned up version of the file path that only contains the path
    /// while supporting renamed/moved file paths with " -> " in it
    /// starts with "a/..." or "b/..."
    public var cleanedPath: String {
        guard let filePath = path.split(separator: " -> ").last else { return path }
        return String(filePath)
    }

    /// A path to the file on the disk including file name.
    /// File path is always relative to a repository root.
    public private(set) var path: String

    // Commit SHA from which the status was created
    public private(set) var sha: String?

    public private(set) var stats: GitFileStats?
    
    /// Current file state
    public private(set) var state: State
    
    /// Determines whether a status is a conflicted status or not
    public var hasConflicts: Bool {
        return state.conflict != nil
    }
    
    /// Indicates whether a file is staged for commit or not
    public var hasChangesInIndex: Bool {
        switch state.index {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }
    
    /// Indicates whether a file is changed in the worktree, but still not staged for commit
    public var hasChangesInWorktree: Bool {
        switch state.worktree {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }


    public var diffModificationState: GitDiffHunkLineType {
        switch state.index {
        case .deleted:
            return .deletion
        case.added:
            return .addition
        default:
            return .unchanged
        }
    }
}

extension GitFileStatus {
    /// Status for active (uncommited) change
    static let previewVersionBump = GitFileStatus(
        path: "package.json",
        state: "M",
        sha: nil,
        stats: GitFileStats("1    1   package.json")
    )
    /// Status for active (uncommited) change
    static let previewSwift = GitFileStatus(
        path: "Commitment/Components/FileDiffChangesView.swift",
        state: "M",
        sha: nil,
        stats: GitFileStats("2    1   Commitment/Components/FileDiffChangesView.swift")
    )
}

// MARK: - Types
public extension GitFileStatus {
    
    // MARK: - State
    class State: Codable {
        
        // MARK: - Init
        public required init(index: ModificationState, worktree: ModificationState) {
            self.index = index
            self.worktree = worktree
        }
        
        internal convenience init(lhs: String, rhs: String) {
            let index = ModificationState(rawValue: lhs) ?? .unknown
            let worktree = ModificationState(rawValue: rhs) ?? .unknown

            self.init(index: index, worktree: worktree)
        }
        
        /// Shows the modification state of the index
        public var index: ModificationState
        
        /// Shows the modification status of the working tree
        public var worktree: ModificationState
        
        /// Shows the current merge conflict state. Returns nil when there is no conflict
        public var conflict: ConflictState? {
            switch (index, worktree) {
            // DD
            case (.deleted, .deleted): return .unmergedDeletedBoth
            
            // AU
            case (.added, .unmerged): return .unmergedAddedByUs
               
            // UD
            case (.unmerged, .deleted): return .unmergedDeletedByThem
                
            // UA
            case (.unmerged, .added): return .unmergedAddedByThem
                
            // DU
            case (.deleted, .unmerged): return .unmergedDeletedByUs
                
            // AA
            case (.added, .added): return .unmergedAddedBoth
                
            // UU
            case (.unmerged, .unmerged): return .unmergedModifiedBoth
                
            default: return nil
            }
        }
    }
    
    // MARK: - ModificationState
    enum ModificationState: String, Codable {
        
        case modified = "M"
        case added = "A"
        case deleted = "D"
        case renamed = "R"
        case copied = "C"
        case untracked = "?"
        case ignored = "!"
        case unmerged = "U"
        case unmodified = " "
        
        case unknown = "Z"
    }
    
    // MARK: - ConflictState
    enum ConflictState: Codable {
        
        case unmergedAddedBoth
        case unmergedAddedByUs
        case unmergedAddedByThem
        
        case unmergedDeletedBoth
        case unmergedDeletedByUs
        case unmergedDeletedByThem
        
        case unmergedModifiedBoth
    }
}

extension GitFileStatus.State: Hashable {
    public static func == (lhs: GitFileStatus.State, rhs: GitFileStatus.State) -> Bool {
        return lhs.index == rhs.index &&
        lhs.worktree == rhs.worktree
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(worktree)
    }
}

extension GitFileStatus: Hashable {
    public static func == (lhs: GitFileStatus, rhs: GitFileStatus) -> Bool {
        lhs.path == rhs.path &&
        lhs.state == rhs.state
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(state)
    }
}
