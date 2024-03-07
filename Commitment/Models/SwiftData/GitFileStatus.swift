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
import SwiftData

/// Describes a single file status
@Model final class GitFileStatus: Identifiable {
    // MARK: - Init
    init(path: String, state: String, sha: String? = nil, stats: GitFileStats? = nil) {
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
            lhs = GitFileStatusModificationState.unknown.rawValue
            rhs = GitFileStatusModificationState.unknown.rawValue
        }
        
        self.state = GitFileStatusState(lhs: lhs, rhs: rhs)
    }
    
    @Attribute(.unique)
    var id: String {
        if let sha {
            return self.path + sha
        }

        return self.path
    }

    var repository: CodeRepository?
    
    @Relationship(deleteRule: .cascade, inverse: \GitDiff.status)
    var diff: GitDiff? = nil

    /// Cleaned up version of the file path that only contains the path
    /// while supporting renamed/moved file paths with " -> " in it
    /// starts with "a/..." or "b/..."
    var cleanedPath: String {
        guard let filePath = path.split(separator: " -> ").last else { return path }
        return String(filePath)
    }
    
    /// A path to the file on the disk including file name.
    /// File path is always relative to a repository root.
    private(set) var path: String
    
    // Commit SHA from which the status was created
    private(set) var sha: String?
    
    var stats: GitFileStats?
    
    /// Current file state
    var state: GitFileStatusState
    
    /// Determines whether a status is a conflicted status or not
    var hasConflicts: Bool {
        return state.conflict != nil
    }
    
    /// Indicates whether a file is staged for commit or not
    var hasChangesInIndex: Bool {
        switch state.index {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }
    
    /// Indicates whether a file is changed in the worktree, but still not staged for commit
    var hasChangesInWorktree: Bool {
        switch state.worktree {
        case .unmodified, .ignored, .untracked, .unknown:
            return false
        default:
            return true
        }
    }
    
    
    var diffModificationState: GitDiffHunkLineType {
        switch state.index {
        case .deleted:
            return .deletion
        case.added:
            return .addition
        default:
            return .context
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

// MARK: - ModificationState
enum GitFileStatusModificationState: String, Codable {
    
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
enum GitFileStatusConflictState: Codable {
    
    case unmergedAddedBoth
    case unmergedAddedByUs
    case unmergedAddedByThem
    
    case unmergedDeletedBoth
    case unmergedDeletedByUs
    case unmergedDeletedByThem
    
    case unmergedModifiedBoth
}

// MARK: - Types

// MARK: - State
struct GitFileStatusState: Codable, Equatable {

    // MARK: - Init
    init(index: GitFileStatusModificationState, worktree: GitFileStatusModificationState) {
        self.index = index
        self.worktree = worktree
    }
    
    init(lhs: String, rhs: String) {
        let index = GitFileStatusModificationState(rawValue: lhs) ?? .unknown
        let worktree = GitFileStatusModificationState(rawValue: rhs) ?? .unknown
        
        self.init(index: index, worktree: worktree)
    }
    
    /// Shows the modification state of the index
    var index: GitFileStatusModificationState
    
    /// Shows the modification status of the working tree
    var worktree: GitFileStatusModificationState
    
    /// Shows the current merge conflict state. Returns nil when there is no conflict
    var conflict: GitFileStatusConflictState? {
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

//extension GitFileStatusState: Hashable {
//    static func == (lhs: GitFileStatusState, rhs: GitFileStatusState) -> Bool {
//        return lhs.index == rhs.index &&
//        lhs.worktree == rhs.worktree
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(index)
//        hasher.combine(worktree)
//    }
//}

//extension GitFileStatus: Hashable {
//    static func == (lhs: GitFileStatus, rhs: GitFileStatus) -> Bool {
//        lhs.path == rhs.path &&
//        lhs.state == rhs.state
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(path)
//        hasher.combine(state)
//    }
//}
