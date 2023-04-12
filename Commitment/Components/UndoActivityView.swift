//
//  UndoActivityView.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct UndoActivityView: View {
    @EnvironmentObject private var repo: RepoState

    var body: some View {
        ZStack {
            ForEach(repo.undo.stack) { action in
                Text("action")
            }
        }
    }
}

struct UndoActivityView_Previews: PreviewProvider {
    static var previews: some View {
        UndoActivityView()
    }
}
