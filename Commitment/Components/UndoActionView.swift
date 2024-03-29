//
//  UndoActionView.swift
//  Commitment
//
//  Created by Stef Kors on 12/04/2023.
//

import SwiftUI

struct UndoActionView: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var shell: Shell
    @EnvironmentObject private var undoState: UndoState
    let action: UndoAction
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group {
                    Text("\(action.type.rawValue.capitalized) ") + Text("\(action.createdAt.formatted(.relative(presentation: .named, unitsStyle: .wide)))")
                }
                .foregroundColor(.secondary)

                if let subtitle = action.subtitle {
                    Text(subtitle)
                        .lineLimit(1)
                        .help(subtitle)
                }
            }
            Spacer(minLength: 20)
            Button("Undo", action: {
                Task {
                    switch action.type {
                    case .stash:
                        try await shell.applyLastStash()
                        self.undoState.stack.removeLast()
                    case .discardChanges:
                        try await shell.applyLastStash()
                        self.undoState.stack.removeLast()
                    case .commit:
                        try await shell.undoLastCommit()
                        self.undoState.stack.removeLast()
                    }

                    try await  self.repository.refreshDiffsAndStatus()
                }
            })
            .buttonStyle(.undo)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
        .background(.thinMaterial)
        .cornerRadius(4)
        .shadow(radius: 4, y: 2)

    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - (position + 1))
        return self
            .offset(x: 0, y: offset * 6)
            .scaleEffect(x: 1 - (offset / 30))
    }
}

struct UndoActionView_Previews: PreviewProvider {
    static let action: UndoAction = .sampleCommit
    static let samples: [UndoAction] = [.sampleCommit, .sampleDiscardChanges, .sample, .sampleDiscardChanges, .sample]

    static var previews: some View {
        UndoActionView(action: action)
            .frame(maxWidth: 250)
            .scenePadding()

        ZStack {
            ForEach(0..<samples.count, id: \.self) { index in
                UndoActionView(action: samples[index])
                    .stacked(at: index, in: samples.count)
            }
        }
        .frame(maxWidth: 250)
        .padding(50)
    }
}
