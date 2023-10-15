//
//  ViewState.swift
//  Commitment
//
//  Created by Stef Kors on 05/03/2023.
//

import SwiftUI

class ViewState: ObservableObject {
    // Active Changes Views
    @Published var activeChangesSelection: GitFileStatus? = nil

    @Published var activeCommitSelection: Commit.ID? = nil
    @Published var activeCommitFileSelection: GitFileStatus.ID? = nil
    // TODO: grab open / close logic from old RepoState
    @Published var isBranchSelectOpen: Bool = false
    @Published var isRepoSelectOpen: Bool = false
    @Published var activeRepositoryId: CodeRepository.ID? = nil
}
