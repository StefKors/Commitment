//
//  DiffListView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

struct DiffListView: View {

    var diffs: [GitDiff]? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let diffs, !diffs.isEmpty {
                    ForEach(diffs, id: \.description) { diff in
                        DiffView(diff: diff)
                    }
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
}

struct DiffListView_Previews: PreviewProvider {
    static var previews: some View {
        DiffListView()
    }
}
