//
//  ToolbarOpenCommitWindowView.swift
//  Commitment
//
//  Created by Stef Kors on 28/03/2023.
//

import SwiftUI

struct ToolbarOpenCommitWindowView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button {
            // TODO: Check open window behaviour
            openWindow(id: "CommitWindow")
        } label: {
            HStack {
                Image(systemName: "macwindow.badge.plus")
                    .imageScale(.medium)

                VStack(alignment: .leading) {
                    Text("Open Commit Window")
                    Text("ta daaa")
                }
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(.plain)
    }
}

struct ToolbarOpenCommitWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarOpenCommitWindowView()
    }
}
