//
//  FileChangeIconView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI


struct FileChangeIconView: View {
    let type: GitFileStatus.ModificationState

    var body: some View {
        HStack {
            switch type {
            case .modified:
                Image(systemName: "m.square")
                    .foregroundColor(.orange)
            case .added:
                Image(systemName: "plus.square")
                    .foregroundColor(.green)
            case .deleted:
                Image(systemName: "minus.square")
                    .foregroundColor(.red)
            case .renamed:
                Image(systemName: "r.square")
                    .foregroundColor(.blue)
            case .copied:
                Image(systemName: "c.square")
                    .foregroundColor(.primary)
            case .untracked:
                Image(systemName: "square.dashed")
                    .foregroundColor(.primary)
            case .ignored:
                Image(systemName: "dot.square")
                    .foregroundStyle(.secondary, .clear)
            case .unmerged:
                Image(systemName: "m.square")
                    .foregroundStyle(.secondary, .clear)
            case .unmodified:
                Image(systemName: "dot.square")
                    .foregroundColor(.orange)
            case .unknown:
                Image(systemName: "questionmark.square.dashed")
                    .foregroundColor(.primary)

            }
        }.help(type.rawValue)
    }
}

struct FileChangeIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FileChangeIconView(type:.modified)
            FileChangeIconView(type:.added)
            FileChangeIconView(type:.deleted)
            FileChangeIconView(type:.renamed)
            FileChangeIconView(type:.copied)
            FileChangeIconView(type:.untracked)
            FileChangeIconView(type:.ignored)
            FileChangeIconView(type:.unmerged)
            FileChangeIconView(type:.unmodified)
            FileChangeIconView(type:.unknown)
        }
    }
}
