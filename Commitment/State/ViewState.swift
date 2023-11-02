//
//  ViewState.swift
//  Commitment
//
//  Created by Stef Kors on 05/03/2023.
//

import SwiftUI

class ViewState: ObservableObject {
    // Active Changes Views
    @Published var activeChangeSelection: GitFileStatus.ID? = nil

    @Published var activeCommitSelection: Commit.ID? = nil
    // TODO: revert string type back to id GitFileStatus.ID
    @Published var activeCommitFileSelection: String? = nil
    @Published var activeRepositoryId: CodeRepository.ID? = nil
}
