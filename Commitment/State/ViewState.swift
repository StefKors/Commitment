//
//  ViewState.swift
//  Commitment
//
//  Created by Stef Kors on 05/03/2023.
//

import SwiftUI

class ViewState: ObservableObject {
    @Published var activeChangesSelection: GitFileStatus.ID? = nil
    @Published var activeCommitSelection: Commit.ID? = nil
    @Published var activeCommitFileSelection: GitFileStatus.ID? = nil
}
