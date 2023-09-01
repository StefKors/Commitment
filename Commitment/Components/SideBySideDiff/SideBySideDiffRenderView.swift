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
                    HunkView(hunk: hunk)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach(GitDiff.Preview.toDiff(GitDiff.Preview.configChanges)!.hunks, id: \.id) { hunk in
                HunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

struct HunkView: View {
    let hunk: GitDiffHunk
    private let lineheight: CGFloat = 20
    var body: some View {
        // GeometryReader(content: {
        //     geometry in
        HunkHeaderLineView(header: hunk.header)
        ZStack {
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .fill(Color(red: 0.944345, green: 0.604528, blue: 0.215502, opacity: 0.3))
                    .frame(height: max(toDistance(val: hunk.oldLineSpan - 6), 4))
                    .offset(y: toDistance(val: 3))

                VStack {
                    SideBySideGutterView(
                        startA: toDistance(val: 3),
                        distanceA: toDistance(val: hunk.oldLineSpan - 6),
                        startB: toDistance(val: 3),
                        distanceB: toDistance(val: hunk.newLineSpan - 6)
                    )
                    Spacer()
                }
                .frame(width: 60)

                Rectangle()
                    .fill(Color(red: 0.674407, green: 0.222846, blue: 0.619637, opacity: 0.3))
                    .frame(height: max(toDistance(val: hunk.newLineSpan - 6), 4))
                    .offset(y: toDistance(val: 3))
            }

            HStack(alignment: .top, spacing: 0) {
                VStack(spacing: 0) {
                    ForEach(hunk.lines, id: \.id) { line  in
                        // HStack(alignment: .top, spacing: 0) {
                        // VStack(spacing: 0) {
                        // Divider()
                        // .overlay(content: {
                        //     if line.type == .addition {
                        //         Color.accentColor.frame(height: 1)
                        //     }
                        // })
                        if line.type == .deletion {
                            SideBySideDeletionDiffLineView(lineNumber: line.oldLineNumber, text: line.text)
                        } else if line.type == .unchanged {
                            SideBySideUnchangedDiffLineView(lineNumber: line.oldLineNumber, text: line.text)
                        }
                        //     }
                        // }
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

                VStack {}
                    .frame(width: 60)


                VStack(spacing: 0) {
                    ForEach(hunk.lines, id: \.id) { line  in
                        // HStack(spacing: 0) {
                        //     VStack(spacing: 0) {
                        // Divider()
                        if line.type == .addition {
                            SideBySideAdditionDiffLineView(lineNumber: line.newLineNumber, text: line.text)
                        } else if line.type == .deletion {
                            // Rectangle()
                            //     .frame(height: 0)
                            //     .overlay(alignment: .top) {
                            //         Rectangle()
                            //             .frame(height: 4, alignment: .top)
                            //             .foregroundStyle(Color(red: 0.674407, green: 0.222846, blue: 0.619637, opacity: 0.3))
                            //     }
                        } else if line.type == .unchanged {
                            SideBySideUnchangedDiffLineView(lineNumber: line.newLineNumber, text: line.text)
                        }
                        //     }
                        // }
                    }
                    Spacer()
                }
            }
            // })
            .task {
                // var arches: [GutterArch] = []
                print(hunk)
                //
                // arches.append(
                //     GutterArch(
                //         startA: CGFloat(hunk.oldLineStart),
                //         distanceA: CGFloat(hunk.oldLineSpan),
                //         startB: CGFloat(hunk.newLineStart),
                //         distanceB: CGFloat(hunk.newLineSpan)
                //     )
                // )
                // for (offset, line) in hunk.lines.enumerated() {
                //     if line.type == .addition {
                //
                //         arches.append(GutterArch(startA: 0, endA: 0, startB: 0, endB: 0))
                //     }
                // }
            }
        }
    }

    func toDistance(val: Int) -> CGFloat {
        return CGFloat(val)*lineheight
    }
}

struct GutterArch {
    var startA: CGFloat
    var endA: CGFloat
    var startB: CGFloat
    var endB: CGFloat
}


struct SideBySideUnchangedDiffLineView: View {
    let lineNumber: Int?
    let text: String
    private let image: String? = nil
    private let color: Color = .clear
    private let colorOpaque: Color = .clear.opacity(0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: .clear)

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
    private let color: Color = Color(red: 0.944345, green: 0.604528, blue: 0.215502, opacity: 0.3)
    private let colorOpaque: Color = Color(red: 0.944345, green: 0.604528, blue: 0.215502, opacity: 0.3) //.opacity(0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: .clear)

            ZStack(alignment: .center) {
                // colorOpaque
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 8))

            ZStack(alignment: .leading) {
                // colorOpaque
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
    private let color: Color = Color(red: 0.674407, green: 0.222846, blue: 0.619637, opacity: 0.3)
    private let colorOpaque: Color = Color(red: 0.674407, green: 0.222846, blue: 0.619637, opacity: 0.3)

    var body: some View {
        HStack(spacing: 0) {
            DiffLineNumberView(number: lineNumber, color: .clear)

            ZStack(alignment: .center) {
                // colorOpaque
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 8))

            ZStack(alignment: .leading) {
                // colorOpaque
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
