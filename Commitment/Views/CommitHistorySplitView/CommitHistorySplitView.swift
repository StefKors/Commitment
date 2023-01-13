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
    @SceneStorage("DetailView.selectedTab") private var sidebarSelection: Int = 0
    @State var segmentationSelection : SidebarViewSelection = .changes

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

                TextEditorView()
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
            if let index = sidebarSelection, let commits = repo.commits {
                Text("ComitView \(index)")
                CommitView(commit: commits[index])
            } else {
                Text("nothing selected")
            }
        }
    }
}
