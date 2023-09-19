//
//  SideBySideDiffRenderView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI
// TODO: https://www.avanderlee.com/swiftui/previews-different-states/#creating-a-preview-for-each-dynamic-type-size

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

#Preview("Config Changes") {
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

#Preview("Version Bump") {
    ScrollView {
        VStack {
            ForEach(GitDiff.Preview.toDiff(GitDiff.Preview.versionBump)!.hunks, id: \.id) { hunk in
                HunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Version Bump (unified)") {
    ScrollView {
        VStack {
            ForEach(GitDiff.Preview.toDiff(GitDiff.Preview.versionBump)!.hunks, id: \.id) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Side by Side sample") {
    ScrollView {
        VStack {
            ForEach(GitDiff.Preview.toDiff(GitDiff.Preview.sideBySideSample)!.hunks, id: \.id) { hunk in
                HunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}

#Preview("Side by Side sample (unified)") {
    ScrollView {
        VStack {
            ForEach(GitDiff.Preview.toDiff(GitDiff.Preview.sideBySideSample)!.hunks, id: \.id) { hunk in
                DiffHunkView(hunk: hunk)
            }
        }
        .border(Color.black, width: 1)
    }
    .frame(width: 900, height: 800)
    .scenePadding()
}





struct HunkView: View {
    let hunk: GitDiffHunk

    @State private var isHovering: Bool = false
    private let lineheight: CGFloat = 20
    private let minheight: CGFloat = 4

    // TODO: should probably not be hardcoded index
    private var indexOfFirstChange: Int {
        return hunk.lines.firstIndex(where: { line in
            return line.type != .unchanged
        }) ?? 3
    }

    private var oldSideTypeRelativePadding: CGFloat {
        // we want to draw a different line of the left side based on the type of change

        // a addition we want to draw a full lineheight line
        // a deletion we want to draw a thin line


        let lineToCheck = hunk.lines.first { line in
            return line.type == .deletion
        }
        if lineToCheck?.type == .addition {
            return 0
        }

        if lineToCheck?.type == .deletion {
            return lineheight
        }

        return 0
    }

    var oldSideHeight: CGFloat {
        // Number of lines * lineheight with some bounds
        // Add additional padding for certain line types
        max(toDistance(val: hunk.oldLineSpan - 6), minheight) + oldSideTypeRelativePadding
    }

    private var newSideTypeRelativePadding: CGFloat {
        // we want to draw a different line of the right side based on the type of change
        let lineToCheck = hunk.lines.first { line in
            return line.type == .addition
        }
        if lineToCheck?.type == .addition {
            return lineheight
        }

        if lineToCheck?.type == .deletion {
            return 0
        }

        return 0
    }

    var newSideHeight: CGFloat {
        max(toDistance(val: hunk.newLineSpan - 6), minheight) + newSideTypeRelativePadding
    }

    var body: some View {
        // GeometryReader(content: {
        //     geometry in
        HunkHeaderLineView(header: hunk.header)
        ZStack {
            let firstChangeOffset = toDistance(val: indexOfFirstChange)

            // Background style of side by side
            HStack(alignment: .top, spacing: 0) {
                Rectangle()
                    .fill(Color.systemOrange.quaternary)
                    .frame(height: oldSideHeight)
                    .offset(y: firstChangeOffset)

                VStack {
                    SideBySideGutterView(
                        startA: firstChangeOffset,
                        distanceA: oldSideHeight,
                        startB: firstChangeOffset,
                        distanceB: newSideHeight
                    )
                    Spacer()
                }
                .frame(width: 60)

                Rectangle()
                    .fill(Color.systemPurple.quaternary)
                    .frame(height: newSideHeight)
                    .offset(y: firstChangeOffset)
            }
            .opacity(isHovering ? 1 : 0.5)

            // Foreground text of side by side
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
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


                VStack(alignment: .leading, spacing: 0) {
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
            .onHover(perform: { hovering in
                withAnimation(.smooth) {
                    isHovering = hovering
                }
            })
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
