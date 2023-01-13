//
//  CommitHistorySplitView.swift
//  Difference
//
//  Created by Stef Kors on 18/09/2022.
//

import SwiftUI
import Git

enum SidebarViewSelection: String, CaseIterable {
    case changes = "Changes"
    case history = "History"
}

struct CommitHistorySplitView: View {
    @EnvironmentObject var repo: RepoState
    @State private var segmentationSelection : SidebarViewSelection = .changes
    @State private var message: String = ""

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                NavigationStack {
                    List {
                        switch segmentationSelection {
                        case .history:
                            if let commits = repo.commits {
                                ForEach(commits.indices, id: \.self) { index in
                                    NavigationLink(value: commits[index], label: {
                                        SidebarCommitLabelView(commit: commits[index])
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                        case .changes:
                            if let files = repo.status?.files {
                                ForEach(files.indices, id: \.self) { index in
                                    NavigationLink(value: files[index], label: {
                                        GitFileStatusView(status: files[index])
                                    })
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .listStyle(.sidebar)
                }
                .navigationDestination(for: GitFileStatus.self) { status in
                    ScrollView(.vertical) {
                        if let diff = repo.diffs.first { $0.addedFile.contains(status.path) } {
                            DiffView(status: status, diff: diff)
                                .scenePadding()
                        }
                    }
                }
                .navigationDestination(for: GitLogRecord.self) { commit in
                    Text("commit number \(commit.subject)")
                }

                Divider()
                TextEditorView(isDisabled: repo.diffs.isEmpty)
                    .background(.thinMaterial)
            }
            .toolbar(content: {
                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    Picker("", selection: $segmentationSelection) {
                        ForEach(SidebarViewSelection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    AddRepoView()
                }

            })
        } detail: {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("No local changes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: true, vertical: false)
                    Text("There are no uncommited changes in this repository. Here are some friendly suggestions for what to do next:")
                        .lineSpacing(4)
                        // .font(.body)
                }
                WelcomeRepoListView()
            }
            .frame(maxWidth: 400)
            .padding()

        }
    }
}
