//
//  SideBySideHunkView.swift
//  Commitment
//
//  Created by Stef Kors on 29/02/2024.
//

import SwiftUI

struct SideBySideHunkView: View {
    let hunk: GitDiffHunk

    @State private var isHovering: Bool = false
    private let lineheight: CGFloat = 20
    private let minheight: CGFloat = 4

    private var sortedLines: [GitDiffHunkLine] {
        hunk.lines.sorted { lhs, rhs in
            return (lhs.oldLineNumber ?? lhs.newLineNumber ?? 0) < (rhs.oldLineNumber ?? rhs.newLineNumber ?? 0)
        }
    }

    // TODO: should probably not be hardcoded index
    private var indexOfFirstChange: Int {
        return sortedLines.firstIndex(where: { line in
            return line.type != .context
        }) ?? 3
    }

    private var oldSideTypeRelativePadding: CGFloat {
        // we want to draw a different line of the left side based on the type of change

        // a addition we want to draw a full lineheight line
        // a deletion we want to draw a thin line

        let lineToCheck = sortedLines.first { line in
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
        let numOfDeletions = sortedLines.filter { $0.type == .deletion}.count

        return max(toDistance(val: numOfDeletions), minheight) //+ oldSideTypeRelativePadding
    }

    private var newSideTypeRelativePadding: CGFloat {
        // we want to draw a different line of the right side based on the type of change
        let lineToCheck = sortedLines.first { line in
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
        let numOfAdditions = sortedLines.filter { $0.type == .addition}.count
        return max(toDistance(val: numOfAdditions), minheight) //+ newSideTypeRelativePadding
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
                    .fill(Color(.gitHubDiffRed))
                //                    .fill(Color.systemOrange.quaternary)
                    .frame(height: oldSideHeight)
                    .offset(y: firstChangeOffset)

                VStack {
                    SideBySideGutterView(
                        startA: firstChangeOffset,
                        distanceA: oldSideHeight,
                        startB: firstChangeOffset,
                        distanceB: newSideHeight
                    )
                }
                .frame(width: 60)

                Rectangle()
                    .fill(Color(.gitHubDiffGreen))
                //                    .fill(Color.systemPurple.quaternary)
                    .frame(height: newSideHeight)
                    .offset(y: firstChangeOffset)
            }
            .opacity(isHovering ? 1 : 0.5)

            // Foreground text of side by side
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(sortedLines, id: \.id) { line  in
                        // HStack(alignment: .top, spacing: 0) {
                        // VStack(spacing: 0) {
                        // Divider()
                        // .overlay(content: {
                        //     if line.type == .addition {
                        //         Color.accentColor.frame(height: 1)
                        //     }
                        // })
                        if line.type == .deletion {
                            SideBySideDiffLineView(lineNumber: line.oldLineNumber, text: line.text, type: .deletion)
                        } else if line.type == .context {
                            SideBySideDiffLineView(lineNumber: line.oldLineNumber, text: line.text, type: .context)
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
                    ForEach(sortedLines, id: \.id) { line  in
                        // HStack(spacing: 0) {
                        //     VStack(spacing: 0) {
                        // Divider()
                        if line.type == .addition {
                            SideBySideDiffLineView(lineNumber: line.newLineNumber, text: line.text, type: .addition)
                        } else if line.type == .deletion {
                            // Rectangle()
                            //     .frame(height: 0)
                            //     .overlay(alignment: .top) {
                            //         Rectangle()
                            //             .frame(height: 4, alignment: .top)
                            //             .foregroundStyle(Color(red: 0.674407, green: 0.222846, blue: 0.619637, opacity: 0.3))
                            //     }
                        } else if line.type == .context {
                            SideBySideDiffLineView(lineNumber: line.newLineNumber, text: line.text, type: .context)
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


#Preview {
    VStack {
        SideBySideHunkView(hunk: .Preview.dataWithCustomContextIndicator)

        SideBySideHunkView(hunk: .Preview.versionBump)
//        SideBySideHunkView(hunk: .Preview.sideBySideSample)
    }
    .modelContainer(.previews)
}
