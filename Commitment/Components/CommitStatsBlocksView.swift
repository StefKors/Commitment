//
//  CommitStatsBlocksView.swift
//  Commitment
//
//  Created by Stef Kors on 07/05/2023.
//

import SwiftUI

struct CommitStatsBlocksView: View {
    let blocks: [GitStatBlockType]

    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(zip(blocks.indices, blocks)), id: \.0) { (index, block) in
                let size: CGFloat = 10
                switch block {
                case .addition:
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color("GitHubDiffGreenBright"))
                        .frame(width: size, height: size)
                case .deletion:
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color("GitHubDiffRedBright"))
                        .frame(width: size, height: size)
                }
            }
        }
    }
}

struct CommitStatsBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        CommitStatsBlocksView(blocks: [.addition, .addition, .deletion, .deletion, .deletion])
    }
}
