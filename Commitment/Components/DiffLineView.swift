//
//  DiffLineView.swift
//  Commitment
//
//  Created by Stef Kors on 12/01/2023.
//

import SwiftUI

struct DiffLineNumberView: View {
    let number: Int?
    let color: Color

    var body: some View {
        ZStack(alignment: .center) {
            color
            if let number {
                Text(number.description)
            }
        }
        .frame(width: 30)
        .font(.system(size: 11))
        .foregroundColor(.secondary)
    }
}

struct DiffLineView: View {
    let line: GitDiffHunkLine
    private let image: String?
    private let color: Color
    private let colorOpaque: Color
    
    init(line: GitDiffHunkLine) {
        self.line = line
        
        switch line.type {
        case .addition:
            self.image = "plus"
            self.color = Color("GitHubDiffGreen")
            self.colorOpaque = color.opacity(0.3)
        case .deletion:
            self.image = "minus"
            self.color = Color("GitHubDiffRed")
            self.colorOpaque = color.opacity(0.3)
        case .unchanged:
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

struct DiffLineView_Previews: PreviewProvider {
    static var previews: some View {
        DiffLineView(line: GitDiffHunkLine.Preview.deletion)

        DiffLineView(line: GitDiffHunkLine.Preview.addition)

        DiffLineView(line: GitDiffHunkLine.Preview.unchanged)
    }
}
