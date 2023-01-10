//
//  DiffView.swift
//  Commitment
//
//  Created by Stef Kors on 04/01/2023.
//

import SwiftUI

struct DiffView: View {
    var diffs: [GitDiff]? = nil

    private let columns = [GridItem(.fixed(25), spacing: 0), GridItem(.flexible(), spacing: 0)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let diffs {
                    ForEach(diffs, id: \.description) { diff in
                        VStack(alignment: .leading, content: {
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

                            LazyVGrid(columns: columns, alignment:  .leading, spacing: 0) {
                                ForEach(diff.hunks, id: \.description) { hunk in
                                    ForEach(hunk.lines, id: \.self) { line in

                                        switch line.type {
                                        case .addition:

                                            HStack {
                                                Text(" A")
                                                Spacer()
                                            }
                                            .background(Color.green.opacity(0.3))

                                            HStack {
                                                Text(line.text)
                                                Spacer()
                                            }
                                            .background(Color.green.opacity(0.2))

                                        case .deletion:

                                            HStack {
                                                Text(" D")
                                                Spacer()
                                            }
                                            .background(Color.red.opacity(0.3))
                                            HStack {
                                                Text(line.text)
                                                Spacer()
                                            }
                                            .background(Color.red.opacity(0.2))
                                        case .unchanged:

                                            HStack {
                                                Text("  ")
                                                Spacer()
                                            }
                                            HStack {
                                                Text(line.text)
                                                Spacer()
                                            }

                                        }

                                    }
                                }
                                .animation(Animation.interpolatingSpring(stiffness: 300, damping: 20), value: diffs)
                                .transition(.slide.animation(Animation.interpolatingSpring(stiffness: 300, damping: 20)))
                            }
                            .fontDesign(.monospaced)
                            // .scenePadding()

                        })
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.separator, lineWidth: 2)
                            // .background(.background)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    }
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
