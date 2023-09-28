//
//  FileStatsView.swift
//  Commitment
//
//  Created by Stef Kors on 03/05/2023.
//

import SwiftUI

struct FileStatsView: View {
    let stats: GitFileStats?

    @AppStorage("SideBySideView") private var sideBySide: Bool = false

    @State private var selection = 0

    var body: some View {
        if let stats {
            HStack {
                Spacer()
                GroupBox {
                    HStack(spacing: 8) {
                        Text("+\(stats.insertions)")
                            .foregroundColor(Color("GitHubDiffGreenBright"))
                        Divider()
                            .frame(maxHeight: 16)
                        Text("-\(stats.deletions)")
                            .foregroundColor(Color("GitHubDiffRedBright"))
                    }
                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .fontDesign(.monospaced)
                .shadow(radius: 4, y: 2)
                .padding()

//                GroupBox {
                    HStack(spacing: 8) {
                        Picker("Choose view style?", selection: $selection) {
                            Image(systemName: "rectangle.split.2x1.fill").tag(0)
                            Image(systemName: "rectangle.split.1x2.fill").tag(1)
                        }
                        .pickerStyle(.segmented)
                            .labelsHidden()
                            .frame(width: 100)
                    }
                    .onChange(of: selection, initial: false, { oldValue, newValue in
                        if selection == 0 {
                            sideBySide = true
                        } else {
                            sideBySide = false
                        }
                    })
//                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .fontDesign(.monospaced)
                .shadow(radius: 4, y: 2)
                .padding()
                .task {
                    selection = sideBySide ? 0 : 1
                }


            }
        }
    }
}

struct FileStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FileStatsView(stats: GitFileStats("4    1    Commitment/Views/AppViews/ActiveChangesMainView.swift"))
    }
}
