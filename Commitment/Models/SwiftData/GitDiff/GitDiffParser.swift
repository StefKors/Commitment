//
//  GitDiffParser.swift
//  GitDiff
//
//  Created by Guillermo Muntaner Perelló on 03/10/2018.
//

import Foundation
import SwiftData


fileprivate func createInt(from substring: Substring?) -> Int? {
    guard let substring else { return nil }
    return Int(substring)
}


/// Regex for parsing git diffs.
///
/// - Group 1: The header old file line start.
/// - Group 2: The header old file line span. If not present it defaults to 1.
/// - Group 3: The header new file line start.
/// - Group 4: The header new file line span. If not present it defaults to 1.
/// - Group 5: The change delta, either "+", "-" or " ".
/// - Group 6: The line itself.
func GitDiffParserParse(unifiedDiff: String, modelContext: ModelContext) -> (addedFile: String, removedFile: String, hunks: [GitDiffHunk]) {

    var addedFile: String?
    var removedFile: String?

    var hunks: [GitDiffHunk] = []
    var currentHunk: GitDiffHunk? = nil
    var currentHunkOldCount: Int = 0
    var currentHunkNewCount: Int = 0
    var header: String?

    modelContext.autosaveEnabled = false

    // https://regex101.com/r/C4tcQ8/1
    let newregex = /^(?:(?:@@ -(?<oldLineStartString>\d+),?(?<oldLineSpanString>\d+)? \+(?<newLineStartString>\d+),?(?<newLineSpanString>\d+)? @@)|(?<delta>[-+=\s])(?<text>.*))/

    for simpleLine in unifiedDiff.lines {
        // padd empty lines with a white space so we can still parse them
        let line = simpleLine.isEmpty ? " " : simpleLine

        if line.starts(with: "@@ ") {
            header = String(line)
        }
        // Skip headers
        guard !line.starts(with: "+++ ") else {
            addedFile = String(line.dropFirst(4))
            continue
        }
        guard !line.starts(with: "--- ") else {
            removedFile = String(line.dropFirst(4))
            continue
        }


        if let match = try? newregex.firstMatch(in: line) {

            if let oldLineStartString = match.output.oldLineStartString, let oldLineStart = Int(oldLineStartString),
               let newLineStartString = match.output.newLineStartString, let newLineStart = Int(newLineStartString) {
                let oldLineSpan = createInt(from: match.output.oldLineSpanString) ?? 1
                let newLineSpan = createInt(from: match.output.newLineSpanString) ?? 1

                if let currentHunk = currentHunk {
                    hunks.append(currentHunk)
                }

                currentHunkOldCount = oldLineStart
                currentHunkNewCount = newLineStart

                let hunk = GitDiffHunk(
                    oldLineStart: oldLineStart,
                    oldLineSpan: oldLineSpan,
                    newLineStart: newLineStart,
                    newLineSpan: newLineSpan,
                    header: header,
                    lines: [])

                modelContext.insert(hunk)

                currentHunk = hunk
            } else if let delta = match.output.delta,
                      let text = match.output.text {
                var oldNum: Int? = nil
                var newNum: Int? = nil
                var lineType: GitDiffHunkLineType
                switch delta {
                case "-":
                    lineType = .deletion
                    oldNum = currentHunkOldCount
                    currentHunkOldCount += 1
                case "+":
                    lineType = .addition
                    newNum = currentHunkNewCount
                    currentHunkNewCount += 1
                case " ", "=":
                    lineType = .context
                    oldNum = currentHunkOldCount
                    newNum = currentHunkNewCount
                    currentHunkOldCount += 1
                    currentHunkNewCount += 1
                default: fatalError("Unexpected group 2 character: \(delta)")
                }

                let newLine = GitDiffHunkLine(type: lineType, text: String(text), oldLineNumber: oldNum, newLineNumber: newNum)
                currentHunk?.lines.append(newLine)
            }

        }
    }

    // Append last hunk
    if let currentHunk = currentHunk {
        hunks.append(currentHunk)
    }

    try? modelContext.save()
    modelContext.autosaveEnabled = true
    guard let added = addedFile, let removed = removedFile else {
        if let _ = unifiedDiff.split(separator: " b/").first {
            return (addedFile: "failed file", removedFile: "failed file", hunks: [])
        } else {
            fatalError("Couldn't find +++ &/or --- files")
        }
    }

    return (addedFile: added, removedFile: removed, hunks: hunks)
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
