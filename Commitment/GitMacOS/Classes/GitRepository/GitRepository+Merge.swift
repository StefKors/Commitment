//
//  GitRepository.swift
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

public extension GitRepository {
    
    func merge(options: GitMergeOptions) throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let task = MergeTask(owner: self, options: options)
        try task.run()
    }
    
    func mergeAbort() throws {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        // Check merge is in progress
        let status = try mergeCheckStatus()
        
        if status.isSquashInProgress {
            // Use git reset merge to abort the merge in the squash mode
            let options = GitResetOptions(); options.mode = .merge
            let task = ResetTask(owner: self, options: options)
            try task.run()
            return
        }
        
        guard status.isMergeInProgress else {
            throw RepositoryError.thereIsNoMergeToAbort
        }
        
        let options = GitMergeOptions(reference: .init(name: ""))
        options.abort = true
        
        let task = MergeTask(owner: self, options: options)
        try task.run()
    }
    
    func mergeCheckStatus() throws -> GitMergeStatus {
        try ensureNoActiveOperations()
        try validateLocalPath()
        
        let status = GitMergeStatus()
        guard let localPath = localPath else { return status }
        
        let gitPath = URL(fileURLWithPath: localPath).appendingPathComponent(".git", isDirectory: true)
        
        // When MERGE_HEAD file exists, it can be assumed that an active merge is in progress
        let mergeHeadPath = gitPath.appendingPathComponent("MERGE_HEAD", isDirectory: false)
        
        // WHEN SQUASH_MSG file exists, it can be assumed that an active squash is in progress
        let squashMessagePath = gitPath.appendingPathComponent("SQUASH_MSG", isDirectory: false)
        
        if FileManager.default.fileExists(atPath: mergeHeadPath.path) {
            status.isMergeInProgress = true
        }
        
        if FileManager.default.fileExists(atPath: squashMessagePath.path) {
            status.isSquashInProgress = true
        }
        
        return status
    }
}
