//
//  GitDiffSummaryView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI

struct DiffSummaryView: View {
    var body: some View {
        HStack {
            Text("999 +++")
                .foregroundColor(Color("GitHubDiffGreenBright"))
            Text("999 ---")
                .foregroundColor(Color("GitHubDiffRedBright"))
        }
    }
}

struct DiffSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiffSummaryView()
    }
}
