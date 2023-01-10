//
//  DiffView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct DiffHunkView: View {
    let hunk: GitDiffHunk

    init(hunk: GitDiffHunk) {
        self.hunk = hunk
    }

    var body: some View {
        ForEach(hunk.lines, id: \.self) { line  in
            DiffLineView(line: line)
        }
    }
}

struct DiffLineView: View {
    let line: GitDiffHunkLine
    private let image: String?
    private let color: Color

    init(line: GitDiffHunkLine) {
        self.line = line

        switch line.type {
        case .addition:
            self.image = "plus"
            self.color = .green
        case .deletion:
            self.image = "minus"
            self.color = .red
        case .unchanged:
            self.image = nil
            self.color = .clear
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .center) {
                color.opacity(0.3)
                if let oldNumber = line.oldLineNumber {
                    Text(oldNumber.description)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))

            ZStack(alignment: .center) {
                color.opacity(0.3)
                if let newNumber = line.newLineNumber {
                    Text(newNumber.description)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))

            ZStack(alignment: .center) {
                color.opacity(0.3)
                if let image {
                    Image(systemName: image)
                }
            }
            .frame(width: 30)
            .font(.system(size: 11))

            Divider()

            ZStack(alignment: .leading) {
                color.opacity(0.2)
                Text(line.text)
                    .padding(.horizontal)
            }
        }
        .frame(height: 20)
    }
}

struct DiffView: View {
    var diffs: [GitDiff]? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let diffs {
                    ForEach(diffs, id: \.description) { diff in
                        VStack(alignment: .leading, spacing: 0, content: {
                            VStack(alignment: .leading, content: {
                                VStack(alignment: .leading, content: {
                                    Text(diff.addedFile)
                                    Text(diff.removedFile)
                                })
                                .padding(.top, 7)
                                .padding(.horizontal, 10)

                                Divider()
                            })
                            .background(.separator)



                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(diff.hunks, id: \.description) { hunk in
                                    Text(hunk.header)
                                    Divider()
                                    DiffHunkView(hunk: hunk)
                                }
                            }
                            .fontDesign(.monospaced)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.separator, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .transition(.move(edge: .top))
                }
            }
            .multilineTextAlignment(.leading)
        }
    }
}

struct DiffView_Previews: PreviewProvider {
    static var previews: some View {
        DiffView()
    }
}
