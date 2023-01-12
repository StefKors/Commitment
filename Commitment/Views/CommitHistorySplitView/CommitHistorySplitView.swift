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
    var allCommits: [RepositoryLogRecord]
    @EnvironmentObject var git: GitClient
    @SceneStorage("DetailView.selectedTab") private var sidebarSelection: Int = 0
    @State var segmentationSelection : SidebarViewSelection = .history
    
    @State private var message: String = ""
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(spacing: 1, pinnedViews: [.sectionFooters]) {
                    Section {
                        switch segmentationSelection {
                        case .history:
                            ForEach(allCommits.indices, id: \.self) { index in
                                NavigationLink(value: index, label: {
                                    SidebarCommitLabelView(commit: allCommits[index])
                                })
                                .buttonStyle(.plain)
                            }
                        case .changes:
                            Text("changes")
                        }
                    } footer: {
                        GroupBox {
                            VStack {
                                TextEditorView(message: $message)
                                    .onSubmit { handleSubmit() }
                                
                                Button(action: { handleSubmit() }) {
                                    Text("Commit")
                                    Spacer()
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(message.isEmpty)
                            }
                            
                        }
                        .background(.thinMaterial)
                        .padding(4)
                        .shadow(radius: 10)
                    }
                }
            }
            .toolbar(content: {
                // TODO: Hide when sidebar is closed
                ToolbarItemGroup(placement: .automatic) {
                    AddRepoView()
                }
                
                ToolbarItemGroup(placement: .automatic) {
                    Picker("", selection: $segmentationSelection) {
                        ForEach(SidebarViewSelection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            })
        } detail: {
            if let index = sidebarSelection {
                Text("ComitView \(index)")
                CommitView(commit: allCommits[index])
            } else {
                Text("nothing selected")
            }
        }
    }
    
    func handleSubmit() {
        git.commit(message: message)
        message = ""
        // self.diffstate.diffs = git.diff()
    }
}
