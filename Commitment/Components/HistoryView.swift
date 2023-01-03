//
//  HistoryView.swift
//  Commitment
//
//  Created by Stef Kors on 03/01/2023.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var git: GitClient

    var body: some View {
        List(git.commitHistory(entries: 100), id: \.hash) { commit in
            VStack(alignment: .leading) {
                Text(commit.author)
                Text(commit.message)
            }.padding()
        }
    }

}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
