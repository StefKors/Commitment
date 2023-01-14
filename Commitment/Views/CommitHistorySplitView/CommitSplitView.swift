//
//  CommitSplitView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI
import Git

struct CommitSplitView: View {
    @EnvironmentObject var repo: RepoState
    var commit: GitLogRecord
    @State private var selection: Int = 0
    var body: some View {
        if let files = repo.status?.files {
            HSplitView {
                // if let diff = repo.shell.diff(at: commit.hash),
                VStack {
                    List(selection: $selection) {
                        ForEach(files.indices, id: \.self) { index in
                            NavigationLink(value: files[index], label: {
                                GitFileStatusView(status: files[index])
                            })
                            .buttonStyle(.plain)
                        }
                    }
                    Spacer()
                }

                ZStack {
                    Rectangle().fill(.background)
                    if let file = files[selection] {
                        VStack {
                            Text("TBD git history diff view")
                            Text(file.path)
                        }
                    }
                }
            }
        }
    }
}

