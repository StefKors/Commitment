//
//  RepositoryWindow.swift
//  Difference
//
//  Created by Stef Kors on 12/08/2022.
//

import SwiftUI
import OSLog

fileprivate let log = Logger(subsystem: "com.stefkors.commitment", category: "RepositoryWindow")

struct RepositoryWindow: View {
//    let repository: CodeRepository

    @State private var shell: Shell? = nil
    @StateObject private var activityState = ActivityState()
    @StateObject private var viewState = ViewState()
    @StateObject private var undoState = UndoState()
    @Environment(CodeRepository.self) private var repository

    /// What am I doing?
    /// Active changes is based per repo
    /// it's a lot of data that ideally we want to persist
    /// perhaps the best "SwiftData" way to do this is to build relational data
    /// link GitFileState to GitRepo or History / GitCommit, so we can use
    /// swiftdata to fetch the file status of a specific commit / changes


    var body: some View {
        Group {
            if shell != nil, let shell {
                LoadedRepositoryView()
                    .environmentObject(activityState)
                    .environmentObject(viewState)
                    .environmentObject(undoState)
                    .environmentObject(shell)
                    .navigationTitle(repository.folderName)
                    .navigationDocument(repository.path)
                    .frame(minWidth: 940)
            } else {
                RepositoryWindowLoadingBarView()
            }
        }
        .task(id: repository) {
            do {
                let url = try repository.bookmark.startUsingTargetURL()
                // TODO: re-save repo with update path?
                repository.path = url

                self.shell = Shell(workspace: url)
                NSDocumentController.shared.noteNewRecentDocumentURL(url)
            } catch {
                log.error("failed to restore bookmark: \(error.localizedDescription)")
            }
        }
    }
}
