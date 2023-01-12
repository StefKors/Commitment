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
    var commits: [RepositoryLogRecord]
    var diffs: [GitDiff]
    var status: GitFileStatusList
    @SceneStorage("DetailView.selectedTab") private var sidebarSelection: Int = 0
    @State var segmentationSelection : SidebarViewSelection = .changes

    @State private var message: String = ""

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack {
                        switch segmentationSelection {
                        case .history:
                            ForEach(commits.indices, id: \.self) { index in
                                NavigationLink(value: index, label: {
                                    SidebarCommitLabelView(commit: commits[index])
                                })
                                .buttonStyle(.plain)
                            }
                        case .changes:
                            ForEach(status.files.indices, id: \.self) { index in
                                Divider()
                                NavigationLink(value: status.files[index], label: {
                                    GitFileStatusView(status: status.files[index])
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                TextEditorView()
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
            if let index = sidebarSelection {
                Text("ComitView \(index)")
                CommitView(commit: commits[index])
            } else {
                Text("nothing selected")
            }
        }
    }
}
