//
//  FileStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct FileStatsView: View {
    let stats: GitFileStats?

    var body: some View {
        if let stats {
            HStack(spacing: 8) {
                Text("++\(stats.insertions)")
                    .foregroundColor(Color("GitHubDiffGreenBright"))
                Divider()
                    .frame(maxHeight: 16)
                Text("--\(stats.deletions)")
                    .foregroundColor(Color("GitHubDiffRedBright"))
                Divider()
            }
            .fontDesign(.monospaced)
        }
    }
}

struct FileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FileStatsView(stats: GitFileStats("4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"))
    }
}
