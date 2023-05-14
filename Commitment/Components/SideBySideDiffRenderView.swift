//
//  SideBySideDiffRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct SideBySideDiffRenderView: View {
    var fileStatus: GitFileStatus
    var diff: GitDiff
    
    var body: some View {
        HStack {
            FileView(fileStatus: fileStatus) {

                ForEach(diff.hunks, id: \.id) { hunk in
                    HunkHeaderLineView(header: hunk.header)
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            ForEach(hunk.lines, id: \.id) { line  in
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Divider()
                                        .overlay(content: {
                                            if line.type == .addition {
                                                Color.accentColor.frame(height: 1)
                                            }
                                        })
                                        if line.type == .deletion {
                                            SideBySideDeletionDiffLineView(lineNumber: line.oldLineNumber, text: line.text)
                                        } else if line.type == .unchanged {
                                            SideBySideUnchangedDiffLineView(lineNumber: line.oldLineNumber, text: line.text)
                                        }
                                    }
                                }
                                // .frame(minHeight: line.type == .addition ? 1 : 0 )
                                // .overlay(content: {
                                //     if line.type == .addition {
                                //         Color.accentColor.frame(height: 2)
                                //     }
                                // })
                                // .border(.red, width: 1, cornerRadius: 4)
                            }
                            Spacer()
                        }

                        VStack(spacing: 0) {
                            ForEach(hunk.lines, id: \.id) { line  in
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Divider()
                                        if line.type == .addition {
                                            SideBySideAdditionDiffLineView(lineNumber: line.newLineNumber, text: line.text)
                                        } else if line.type == .unchanged {
                                            SideBySideUnchangedDiffLineView(lineNumber: line.newLineNumber, text: line.text)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct SideBySideUnchangedDiffLineView: View {
    let lineNumber: Int?
    let text: String
    private let image: String? = nil
    private let color: Color = .clear
    private let colorOpaque: Color = .clear.opacity(0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: color)

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
                HighlightedText(text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}

struct SideBySideDeletionDiffLineView: View {
    let lineNumber: Int?
    let text: String
    private let image: String? = "minus"
    private let color: Color = .accentColor
    private let colorOpaque: Color = .accentColor.opacity(0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: color)

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
                HighlightedText(text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}



struct SideBySideAdditionDiffLineView: View {
    let lineNumber: Int?
    let text: String
    private let image: String? = "plus"
    private let color: Color = .accentColor
    private let colorOpaque: Color = .accentColor.opacity(0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: color)

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
                HighlightedText(text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}


struct SideBySideDiffLineView: View {
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


// struct DiffRenderView_Previews: PreviewProvider {
//     static var previews: some View {
//         DiffRenderView(diff: GitDiff.Preview.toDiff(GitDiff.Preview.versionBump))
//             .padding()
//     }
// }
