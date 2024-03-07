//
//  SideBySideDiffRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI
// TODO: https://www.avanderlee.com/swiftui/previews-different-states/#creating-a-preview-for-each-dynamic-type-size

struct SideBySideDiffRenderView: View {
    var fileStatus: GitFileStatus
    var diff: GitDiff

    var body: some View {
        HStack {
            FileView(fileStatus: fileStatus) {
                ForEach(diff.hunks, id: \.id) { hunk in
                    SideBySideHunkView(hunk: hunk)
                        .id(hunk.id)
                }
            }
        }
    }
}

#Preview("Config Changes") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.configChanges, modelContext: .previews).hunks, id: \.id) { hunk in
                SideBySideHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Version Bump") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.versionBump, modelContext: .previews).hunks, id: \.id) { hunk in
                SideBySideHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Version Bump (unified)") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.versionBump, modelContext: .previews).hunks, id: \.id) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Side by Side debug") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.sideBySideDebug, modelContext: .previews).hunks, id: \.id) { hunk in
                SideBySideHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Side by Side sample") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.sideBySideSample, modelContext: .previews).hunks, id: \.id) { hunk in
                SideBySideHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Side by Side sample (unified)") {
    ScrollView {
        VStack {
            ForEach(GitDiff(unifiedDiff: GitDiff.Preview.sideBySideSample, modelContext: .previews).hunks, id: \.id) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}
