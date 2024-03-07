//
//  SideBySideDiffLineView.swift
//  Commitment
//
//  Created by Stef Kors on 29/02/2024.
//

import SwiftUI

struct OldSideBySideDiffLineView: View {
    let line: GitDiffHunkLine
    private let image: String?
    private let color: Color
    private let colorOpaque: Color

    init(line: GitDiffHunkLine) {
        self.line = line

        switch line.type {
        case .addition:
            self.image = "plus"
            self.color = .accentColor
            self.colorOpaque = color.opacity(0.3)
        case .deletion:
            self.image = "minus"
            self.color = .accentColor
            self.colorOpaque = color.opacity(0.3)
        case .context:
            self.image = nil
            self.color = .clear
            self.colorOpaque = .clear
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: line.oldLineNumber, color: color)

            DiffLineNumberView(number: line.newLineNumber, color: color)

            ZStack(alignment: .center) {
                colorOpaque
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 8))

            ZStack(alignment: .leading) {
                colorOpaque
                HighlightedText(line.text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}

//#Preview {
//    OldSideBySideDiffLineView(line: .Preview.addition)
//}
