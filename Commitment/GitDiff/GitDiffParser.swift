//
//  GitDiffParser.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation

internal class GitDiffParser {
    
    /// Regex for parsing git diffs.
    ///
    /// - Group 1: The header old file line start.
    /// - Group 2: The header old file line span. If not present it defaults to 1.
    /// - Group 3: The header new file line start.
    /// - Group 4: The header new file line span. If not present it defaults to 1.
    /// - Group 5: The change delta, either "+", "-" or " ".
    /// - Group 6: The line itself.
    let regex = try! NSRegularExpression(
        pattern: "^(?:(?:@@ -(\\d+),?(\\d+)? \\+(\\d+),?(\\d+)? @@)|([-+\\s])(.*))",
        options: [])
    
    let unifiedDiff: String
    
    init(unifiedDiff: String) {
        self.unifiedDiff = unifiedDiff
    }
    
    func parse() throws -> (addedFile: String, removedFile: String, hunks: [GitDiffHunk]) {
        
        var addedFile: String?
        var removedFile: String?
        
        var hunks: [GitDiffHunk] = []
        var currentHunk: GitDiffHunk?
        
        unifiedDiff.enumerateLines { line, _ in
            // Skip headers
            guard !line.starts(with: "+++ ") else {
                addedFile = String(line.dropFirst(4))
                return
            }
            guard !line.starts(with: "--- ") else {
                removedFile = String(line.dropFirst(4))
                return
            }
            
            if let match = self.regex.firstMatch(in: line, options: [], range: NSMakeRange(0, line.utf16.count)) {
                
                if let oldLineStartString = match.group(1, in: line), let oldLineStart = Int(oldLineStartString),
                    let newLineStartString = match.group(3, in: line), let newLineStart = Int(newLineStartString) {
                    
                    // Get the line spans. If not present default to 1.
                    let oldLineSpan = match.group(2, in: line).flatMap { oldLineSpanString in Int(oldLineSpanString) } ?? 1
                    let newLineSpan = match.group(4, in: line).flatMap { newLineSpanString in Int(newLineSpanString) } ?? 1
                    
                    if let currentHunk = currentHunk {
                        hunks.append(currentHunk)
                    }
                    
                    currentHunk = GitDiffHunk(
                        oldLineStart: oldLineStart,
                        oldLineSpan: oldLineSpan,
                        newLineStart: newLineStart,
                        newLineSpan: newLineSpan,
                        lines: [])
                    
                } else if let delta = match.group(5, in: line),
                    let text = match.group(6, in: line) {
                    
                    guard let hunk = currentHunk else {
                        fatalError("Found a git diff line without a hunk header")
                    }
                    
                    let lineType: GitDiffHunkLineType
                    switch delta {
                    case "-": lineType = .deletion
                    case "+": lineType = .addition
                    case " ": lineType = .unchanged
                    default: fatalError("Unexpected group 2 character: \(delta)")
                    }
                    
                    currentHunk = hunk.copyAppendingLine(GitDiffHunkLine(type: lineType, text: text))
                }
            }
        }
        
        // Append last hunk
        if let currentHunk = currentHunk {
            hunks.append(currentHunk)
        }
        
        guard let added = addedFile, let removed = removedFile else {
            fatalError("Couldn't find +++ &/or --- files")
        }
        
        return (addedFile: added, removedFile: removed, hunks: hunks)
    }
}

internal extension NSTextCheckingResult {
    
    func group(_ group: Int, in string: String) -> String? {
        let nsRange = range(at: group)
        if range.location != NSNotFound {
            return Range(nsRange, in: string)
                .map { range in String(string[range]) }
        }
        return nil
    }
}
