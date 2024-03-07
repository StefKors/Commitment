//
//  SideBySideDiffLineTypeView.swift
//  Commitment
//
//  Created by Stef Kors on 29/02/2024.
//

import SwiftUI

// Note these diff line views don't render their own tinted background because the sidebyside parent view will render the background shape

struct SideBySideDiffLineView: View {
    let lineNumber: Int?
    let text: String
    let type: GitDiffHunkLineType

    private let image: String?

    init(lineNumber: Int?, text: String, type: GitDiffHunkLineType) {
        self.lineNumber = lineNumber
        self.text = text
        self.type = type

        switch type {
        case .context:
            self.image = nil
        case .addition:
            self.image = "plus"
        case .deletion:
            self.image = "minus"
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: .clear)

            ZStack(alignment: .center) {
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 8))

            ZStack(alignment: .leading) {
                HighlightedText(text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}

#Preview("Overview") {
    let line = 2
    let text = "let count = await fetchArticles()"
    return VStack {
        SideBySideDiffLineView(lineNumber: line, text: text, type: .addition)
        SideBySideDiffLineView(lineNumber: line, text: text, type: .deletion)
        SideBySideDiffLineView(lineNumber: line, text: text, type: .context)
    }
}

#Preview("Addition") {
    let line = 2
    let text = "let count = await fetchArticles()"
    return SideBySideDiffLineView(lineNumber: line, text: text, type: .addition)
}

#Preview("Deletion") {
    let line = 2
    let text = "let count = await fetchArticles()"
    return SideBySideDiffLineView(lineNumber: line, text: text, type: .deletion)
}

#Preview("Unchanged") {
    let line = 2
    let text = "let count = await fetchArticles()"
    return SideBySideDiffLineView(lineNumber: line, text: text, type: .context)
}

