//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

enum SplitModeOptions: String, CaseIterable {
    case changes = "Changes"
    case history = "History"
}

struct MainRepoContentView: View {
    @EnvironmentObject private var repo: RepoState

    @State private var modeSelection: SplitModeOptions = .changes
    @State private var message: String = ""

    // @SceneStorage("SplitView.HistorySelectedCommitID") private var commitId: GitLogRecord.ID?
    // @SceneStorage("SplitView.ChangesSelectedFileID") private var fileId: GitFileStatus.ID?
    @State private var commitId: GitLogRecord.ID? = nil
    @State private var fileId: GitFileStatus.ID? = nil
    var body: some View {
        NavigationSplitView(sidebar: {
            VStack {
                switch modeSelection {
                case .history:
                    if let commits = repo.commits {
                        List(commits) { commit in
                            SidebarCommitLabelView(commit: commit)
                        }
                    } else {
                        Spacer()
                    }

                case .changes:
                    if let files = repo.status?.files {
                        List(files, selection: $fileId) { file in
                            GitFileStatusView(status: file)
                        }
                    } else {
                        Spacer()
                    }
                }

                Divider()
                TextEditorView(isDisabled: repo.diffs.isEmpty)
            }
            .toolbar(content: {
                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    SplitModeToggleView(modeSelection: $modeSelection)
                        .disabled(true)
                }

                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    AddRepoView()
                }
            })
        }, detail: {
            switch modeSelection {
            case .history:
                // TODO: Cleanup this if else
                if let commit = repo.commits?.first(where: { $0.id == commitId }), let files = repo.status?.files {
                    CommitSplitView(commit: commit, commitId: commitId)
                        .redacted(reason: .placeholder)
                } else {
                    ContentPlaceholderView()
                }
            case .changes:
                FileDiffChangesView(commitId: commitId, fileId: fileId)
            }
        })
    }
}
